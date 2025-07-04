package com.example.osid.common.response;

import com.example.osid.common.exception.BaseCode;
import com.example.osid.common.exception.SuccessCode;

import com.example.osid.common.response.ErrorResponse.FieldError;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonInclude;

import java.time.LocalDateTime;
import java.util.List;
import lombok.Builder;
import lombok.Getter;
import org.springframework.http.HttpStatus;

@Getter
@Builder
@JsonInclude(JsonInclude.Include.NON_NULL)
public class CommonResponse<T> {

    @Builder.Default
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private final LocalDateTime timestamp = LocalDateTime.now();
    private final boolean isError;
    private final HttpStatus status;
    private final String code;
    private final String message;
    private final T data;
    private final ErrorResponse errorResponse;

    public static <T> CommonResponse<T> ok() {
        return CommonResponse.<T>builder()
                .timestamp(LocalDateTime.now())
                .isError(false)
                .status(SuccessCode.OK.getHttpStatus())
                .code(SuccessCode.OK.getCode())
                .message(SuccessCode.OK.getMessage())
                .data(null)
                .errorResponse(null)
                .build();
    }

    public static <T> CommonResponse<T> ok(T data) {
        return CommonResponse.<T>builder()
                .timestamp(LocalDateTime.now())
                .isError(false)
                .status(SuccessCode.OK.getHttpStatus())
                .code(SuccessCode.OK.getCode())
                .message(SuccessCode.OK.getMessage())
                .data(data)
                .errorResponse(null)
                .build();
    }

    public static <T> CommonResponse<T> created() {
        return CommonResponse.<T>builder()
            .timestamp(LocalDateTime.now())
            .isError(false)
            .status(SuccessCode.CREATED.getHttpStatus())
            .code(SuccessCode.CREATED.getCode())
            .message(SuccessCode.CREATED.getMessage())
            .data(null)
            .errorResponse(null)
            .build();
    }

    public static <T> CommonResponse<T> created(T data) {
        return CommonResponse.<T>builder()
                .timestamp(LocalDateTime.now())
                .isError(false)
                .status(SuccessCode.CREATED.getHttpStatus())
                .code(SuccessCode.CREATED.getCode())
                .message(SuccessCode.CREATED.getMessage())
                .data(data)
                .errorResponse(null)
                .build();
    }

    public static CommonResponse<Void> error(BaseCode baseCode) {
        return CommonResponse.<Void>builder()
                .timestamp(LocalDateTime.now())
                .isError(true)
                .status(baseCode.getHttpStatus())
                .code(baseCode.getCode())
                .message(baseCode.getMessage())
                .data(null)
                .errorResponse(null)
                .build();
    }

    public static CommonResponse<Void> error(BaseCode baseCode, List<ErrorResponse.FieldError> fieldErrors) {
        return CommonResponse.<Void>builder()
                .timestamp(LocalDateTime.now())
                .isError(true)
                .status(baseCode.getHttpStatus())
                .code(baseCode.getCode())
                .message(baseCode.getMessage())
                .data(null)
                .errorResponse(ErrorResponse.of(baseCode, fieldErrors))
                .build();
    }
}
