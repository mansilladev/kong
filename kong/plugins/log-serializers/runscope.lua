local _M = {}

function _M.serialize(ngx)
  
  -- JSON format below based on Runscope Messages resource:
  -- https://www.runscope.com/docs/api/messages#message-create
  -- Not sent: req/res:body_encoding, req:form, res:reason
  return {
    request = {
      url = ngx.var.scheme.."://"..ngx.var.host..":"..ngx.var.server_port..ngx.var.request_uri,
      method = ngx.req.get_method(),
      headers = ngx.req.get_headers(),
      body = ngx.ctx.runscope.req_body
    },
    response = {
      status = ngx.status,
      headers = ngx.resp.get_headers(),
      size = ngx.var.bytes_sent,
      body = ngx.ctx.runscope.res_body,
      timestamp = ngx.req_start_time,
      response_time = ((ngx.ctx.KONG_PROXY_LATENCY or 0) +
                       (ngx.ctx.KONG_WAITING_TIME or 0) +
                       (ngx.ctx.KONG_RECEIVE_TIME or 0)) / 1000
    }
  }
end

return _M
