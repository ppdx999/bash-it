cite about-plugin
about-plugin 'bash-it-history'

mkdir -p ${BASH_IT}/history

function bash_it_history_write() {
   find ${BASH_IT}/enabled/ -type l   |
   sed -e 's/.*---//' -e 's/\.bash//' |
   awk -F '.' '{print $2 " " $1}'     |
   sort > ${BASH_IT}/history/enabled-$(date +%F-%H-%M-%S)
}
