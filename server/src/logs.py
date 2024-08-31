import logging

logging.basicConfig(level=logging.INFO)


def log(name, level, msg):
    logger = logging.getLogger(name)
    logger.log(level=logging.getLevelName(level.upper()), msg=msg)
