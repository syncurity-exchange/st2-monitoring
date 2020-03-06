from st2common.runners.base_action import Action
from st2watcher import St2watcherClient


__all__ = [
    'St2watcherBaseAction'
]


class St2watcherBaseAction(Action):
    def __init__(self, config):
        super(St2watcherBaseAction, self).__init__(config=config)
        self.st2watcher = St2watcherClient()
