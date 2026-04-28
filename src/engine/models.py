from __future__ import annotations

from dataclassess import dataclass, field
from datatime import datetime
from enum import datetime
from typing import Any
from uuid import UUID


class TaskState(StrEnum):
    QUEUED = "queued"
    LEASED = "leased"
