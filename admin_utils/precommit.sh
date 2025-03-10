set -ex

echo $1

DIRS_TO_CHECK=(
  "config"
  "admin_utils"
  "seminars"
  "core_utils"
  "lab_7_llm"
  "lab_8_sft"
  "reference_lab_classification"
  "reference_lab_classification_sft"
  "reference_lab_generation"
  "reference_lab_nli"
  "reference_lab_nli_sft"
  "reference_lab_nmt"
  "reference_lab_nmt_sft"
  "reference_lab_ner"
  "reference_lab_open_qa"
  "reference_lab_summarization"
  "reference_lab_summarization_sft"

)

source venv/bin/activate

export PYTHONPATH=$(pwd)

if [[ "$1" == "fix" ]]; then
    isort .
    autoflake -vv .
    python -m black "${DIRS_TO_CHECK[@]}"
    python config/generate_stubs/generate_labs_stubs.py
fi

python -m pylint "${DIRS_TO_CHECK[@]}"

mypy "${DIRS_TO_CHECK[@]}"

python config/static_checks/check_docstrings.py

python -m flake8 "${DIRS_TO_CHECK[@]}"

sphinx-build -b html -W --keep-going -n . dist -c admin_utils

python -m pytest -m "mark10 and lab_7_llm"
python -m pytest -m "mark10 and lab_8_sft"
