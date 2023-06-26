#!/usr/bin/env zsh

set -e

script_path="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# auto install related tools, if -i given
if [[ $1 == "-I" || $1 == "--install" ]]; then
  echo "Will auto install related tools, continue? (y/n)"
  read sure
  if [[ $sure != "y" ]]; then
    exit 0
  fi
  brew install caarlos0/tap/timer
  brew install terminal-notifier
  exit 0
fi

function set_up_duration {
  vared -p "請輸入任務名稱: " -c task_name
  vared -p "請輸入番茄時間(分鐘): " -c input_task_duration
  vared -p "請輸入休息時間(分鐘): " -c input_rest_duration

  #The defaults unit is seconds, so we need to add "m" after the value to convert the unit to minutes.
  task_duration="${input_task_duration}m"
  rest_duration="${input_rest_duration}m"
}

function rest {
  ascii-image-converter ${script_path}/img/rest.png -C --color-bg &&
  echo "\n你已工作 ${task_duration} 分鐘，休息一下鴨!!! 😃 😃 😃\n" &&
  timer -n '休息時間' ${rest_duration} && terminal-notifier -title '\[ 番茄鐘提醒 ]' \
    -subtitle "你已休息 ${rest_duration} 分鐘" -message '休息時間結束，繼續工作吧 ! 💪 💪 💪'
}

function work {
  ascii-image-converter ${script_path}/img/go_for_it.png -C --color-bg &&
  echo '\n開工了，蔥鴨，衝呀!!! 💪 💪 💪\n' &&
  timer -n ${task_name} ${task_duration} && terminal-notifier -title '\[ 番茄鐘提醒 ]' \
    -subtitle "你已工作 ${input_task_duration} 分鐘" \
    -message "先休息 ${input_rest_duration} 分鐘吧!😃 😃 😃" && rest
}

function task_break_down_reminder {
  echo "\n開工前，你是否已將需求拆成小卡了呢？(y/n)"
  read sure
  if [[ $sure == "y" ]]; then
    set_up_duration && work
  else
    ascii-image-converter ${script_path}/img/break_down.png -C --color-bg &&
  echo '\n還在等什麼，先去拆卡鴨 !!! 🔪 🔪 🔪' &&
  fi
}

function lunch_notification {
  target_time="12:30"

  while true; do
    current_time=$(date +"%H:%M")

    if [[ $current_time == $target_time ]]; then
      ascii-image-converter ${script_path}/img/lunch.png -C --color-bg &&
      echo '\n吃飯了鴨!!!  🍲 🍲 🍲 \n' &&
      terminal-notifier -title '\[ 午餐提醒 ]' \
        -subtitle "吃飯了鴨" -message '吃個飯再繼續吧 !!! 🍖 🍖 🍖'
      break
    fi

    sleep 60
  done
}

function punch_card_notification {
  target_time="18:15"

  while true; do
    current_time=$(date +"%H:%M")

    if [[ $current_time == $target_time ]]; then
      ascii-image-converter ${script_path}/img/punch_card.png -C --color-bg &&
      echo '\n打卡了鴨!!!  🕰️ 🕰️ 🕰️\n' &&
      terminal-notifier -title '\[ 打卡提醒 ]' \
        -subtitle "打卡了鴨" -message '記得打卡鴨 !!! 🕰️ 🕰️ 🕰️'
      break
    fi

    sleep 60
  done
}

lunch_notification &
punch_card_notification &
task_break_down_reminder
