#!/usr/bin/env bash

cd $(dirname $0)

# サンプルで指定しているAWSアカウントのID
before_account_id=123456789012
# あなたのAWSアカウントのID
after_account_id=987654321098

# サンプルで指定しているRDSエンドポイント
before_rds_host="webapp.cluster-abcdefghij12.ap-northeast-1.rds.amazonaws.com"
# あなたの作成したRDSエンドポイント
after_rds_host="webapp.cluster-12abcdefghij.ap-northeast-1.rds.amazonaws.com"

revert=0
target_file_types=("*.yaml" "*.json" "*.md")
target_directory="."

show_help() {
  echo "Usage: $(basename $0) [OPTIONS]"
  echo ""
  echo "Options:"
  echo "  --revert, -r           Revert the replacement"
  echo "  --target-file-type, -t Specify the file type to target (default: *.yaml, *.json, *.md)"
  echo "  --directory, -d        Specify the target directory (default: current directory)"
  echo "  --help, -h             Show this help message"
  echo ""
  echo "Example:"
  echo "  $(basename $0) --directory /path/to/dir --target-file-type '*.txt'"
  echo "  $(basename $0) -r -d /path/to/dir"
}

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --revert|-r)
      revert=1
      shift
      ;;
    --target-file-type|-t)
      shift
      if [[ -n "$1" ]]; then
        target_file_types=("$1")
        shift
      else
        echo "missing argument for --target-file-type" >&2
        exit 1
      fi
      ;;
    --directory|-d)
      shift
      if [[ -n "$1" ]]; then
        target_directory="$1"
        shift
      else
        echo "missing argument for --directory" >&2
        exit 1
      fi
      ;;
    --help|-h)
      show_help
      exit 0
      ;;
    *)
      echo "invalid option: $1" >&2
      exit 1
      ;;
  esac
done

# Linuxの場合、GNUと見なす
if [[ "$(uname -s)" == "Linux" ]]; then
  # GNU sedの場合、-iオプションのみでOK（バックアップファイル作成なし）
  sed_options=(-i)
else
  # BSD/Darwin sedの場合、-i '' と指定する（バックアップファイル作成なし）
  sed_options=(-i '')
fi

if [ ${revert} -eq 0 ]; then
  for file_type in "${target_file_types[@]}"; do
    grep -lr ${before_account_id} --include "${file_type}" ${target_directory} | xargs sed "${sed_options[@]}" -e "s/${before_account_id}/${after_account_id}/"
    grep -lr ${before_rds_host} --include "${file_type}" ${target_directory} | xargs sed "${sed_options[@]}" -e "s/${before_rds_host}/${after_rds_host}/"
  done
else
  for file_type in "${target_file_types[@]}"; do
    grep -lr ${after_account_id} --include "${file_type}" ${target_directory} | xargs sed "${sed_options[@]}" -e "s/${after_account_id}/${before_account_id}/"
    grep -lr ${after_rds_host} --include "${file_type}" ${target_directory} | xargs sed "${sed_options[@]}" -e "s/${after_rds_host}/${before_rds_host}/"
  done
fi

