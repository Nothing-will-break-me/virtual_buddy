import os

import uvicorn

from .config import settings
from argparse import ArgumentParser
from .logs import log


def parse_args():
    parser = ArgumentParser(description='Server additional configuration')
    parser.add_argument('--reload', action='store_true', default=False,
                        help='Whether to reload server when changes in code are detected')
    return parser.parse_args()


if __name__ == "__main__":
    args = parse_args()
    log(__name__, "INFO", settings.__repr__())
    log(__name__, "INFO", os.getcwd())
    uvicorn.run(
        "src.main:app",
        host=settings.SERVER_HOST,
        port=settings.SERVER_PORT,
        reload=args.reload,
        log_config=settings.LOG_CONFIG,
        ssl_certfile=settings.SSL_PUBLIC_KEY_PATH,
        ssl_keyfile=settings.SSL_PRIVATE_KEY_PATH,
    )

