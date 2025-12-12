"""
Type definitions for OpenAPI MCP Server (Python)
"""

from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional, Union
from enum import Enum


class SecurityType(Enum):
    API_KEY = "apiKey"
    HTTP = "http"
    OAUTH2 = "oauth2"
    OPENID_CONNECT = "openIdConnect"
    NONE = "none"


class ParameterLocation(Enum):
    PATH = "path"
    QUERY = "query"
    HEADER = "header"
    COOKIE = "cookie"


class SchemaType(Enum):
    STRING = "string"
    NUMBER = "number"
    INTEGER = "integer"
    BOOLEAN = "boolean"
    ARRAY = "array"
    OBJECT = "object"
    NULL = "null"
    ANY = "any"


@dataclass
class SecurityRequirement:
    type: SecurityType
    scheme: Optional[str] = None
    name: Optional[str] = None
    in_: Optional[str] = None  # 'in' is a keyword in Python
    flows: Optional[List[Dict[str, Any]]] = None
    description: Optional[str] = None
    instruction: Optional[str] = None


@dataclass
class LLMSchema:
    type: SchemaType
    format: Optional[str] = None
    description: Optional[str] = None
    required: Optional[List[str]] = None
    properties: Optional[Dict[str, 'LLMSchema']] = None
    items: Optional['LLMSchema'] = None
    enum: Optional[List[Any]] = None
    pattern: Optional[str] = None
    min_length: Optional[int] = None
    max_length: Optional[int] = None
    minimum: Optional[float] = None
    maximum: Optional[float] = None
    one_of: Optional[List['LLMSchema']] = None
    any_of: Optional[List['LLMSchema']] = None
    all_of: Optional[List['LLMSchema']] = None
    ref: Optional[str] = None
    resolved_type: Optional[str] = None
    example: Optional[Any] = None
    default: Optional[Any] = None
    nullable: Optional[bool] = None
    read_only: Optional[bool] = None
    write_only: Optional[bool] = None


@dataclass
class LLMParameter:
    name: str
    in_: ParameterLocation
    required: bool
    schema: LLMSchema
    description: Optional[str] = None
    example: Optional[Any] = None
    examples: Optional[Dict[str, Any]] = None


@dataclass
class LLMRequestBody:
    required: bool
    content_types: List[str]
    schema: LLMSchema
    description: Optional[str] = None
    examples: Optional[Dict[str, Any]] = None


@dataclass
class LLMResponse:
    status_code: str
    description: str
    content_types: List[str]
    schema: Optional[LLMSchema] = None
    examples: Optional[Dict[str, Any]] = None


@dataclass
class LLMEndpoint:
    id: str  # "GET /users/{id}"
    method: str
    path: str
    security: List[SecurityRequirement]
    parameters: List[LLMParameter]
    responses: List[LLMResponse]
    operation_id: Optional[str] = None
    summary: Optional[str] = None
    description: Optional[str] = None
    tags: Optional[List[str]] = None
    request_body: Optional[LLMRequestBody] = None
    deprecated: Optional[bool] = None
    servers: Optional[List[str]] = None


@dataclass
class APIServer:
    url: str
    description: Optional[str] = None
    variables: Optional[Dict[str, Any]] = None


@dataclass
class APITag:
    name: str
    endpoints: List[str]
    description: Optional[str] = None


@dataclass
class APISummary:
    total_endpoints: int
    endpoints_by_method: Dict[str, int]
    authentication_types: List[str]
    common_content_types: List[str]


@dataclass
class LLMAPISpec:
    title: str
    version: str
    servers: List[APIServer]
    default_security: List[SecurityRequirement]
    endpoints: List[LLMEndpoint]
    schemas: Dict[str, LLMSchema]
    tags: List[APITag]
    summary: APISummary
    description: Optional[str] = None
    terms_of_service: Optional[str] = None
    contact: Optional[Dict[str, str]] = None


@dataclass
class EndpointExecutionGuide:
    endpoint: LLMEndpoint
    curl_example: str
    http_request_example: str
    code_examples: Dict[str, str]
    step_by_step_instructions: List[str]


@dataclass
class N8nWorkflowNode:
    id: str
    name: str
    type: str
    type_version: float
    position: List[int]
    parameters: Dict[str, Any]
    credentials: Optional[Dict[str, str]] = None


@dataclass
class N8nWorkflowConfig:
    name: str
    nodes: List[N8nWorkflowNode]
    connections: Dict[str, Any]
    settings: Dict[str, str]


class OpenAPIParseError(Exception):
    """Error parsing OpenAPI specification"""
    pass


class EndpointNotFoundError(Exception):
    """Endpoint not found in specification"""
    pass
