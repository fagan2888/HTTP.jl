module Connect

export getconnection

using MbedTLS: SSLConfig, SSLContext, setup!, associate!, hostname!, handshake!

import ..@debug


"""
    getconnection(type, host, port) -> IO

Create a new `TCPSocket` or `SSLContext` connection.

Note: this `Connect` module creates simple unadorned connection objects.
The `Connections` module has the same interface but supports connection
reuse and request interleaving.
"""

function getconnection(::Type{TCPSocket}, host::AbstractString,
                                          port::AbstractString)::TCPSocket
    p::UInt = isempty(port) ? UInt(80) : parse(UInt, port)
    @debug 2 "TCP connect: $host:$p..."
    connect(getaddrinfo(host), p)
end

function getconnection(::Type{SSLContext}, host::AbstractString,
                                           port::AbstractString)::SSLContext
    port = isempty(port) ? "443" : port
    @debug 2 "SSL connect: $host:$port..."
    io = SSLContext()
    setup!(io, SSLConfig(false))
    associate!(io, getconnection(TCPSocket, host, port))
    hostname!(io, host)
    handshake!(io)
    return io
end


end # module Connect