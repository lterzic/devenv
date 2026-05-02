#include <cstddef>
#include <stdexcept>
#include <vector>

namespace buffers
{

static constexpr std::size_t DEFAULT_CAPACITY = 16;

template <typename ValueType>
class ring_buffer
{
    public:
    explicit ring_buffer(std::size_t capacity = DEFAULT_CAPACITY)
        : m_data(capacity), m_head(0), m_tail(0), m_size(0)
    {
    }

    ring_buffer(const ring_buffer&) = default;
    ring_buffer(ring_buffer&&) = default;
    ring_buffer& operator=(const ring_buffer&) = default;
    ring_buffer& operator=(ring_buffer&&) = default;
    ~ring_buffer() = default;

    void push(const ValueType& value)
    {
        if (m_size == m_data.size()) {
            throw std::overflow_error {"ring_buffer is full"};
        }
        m_data[m_tail] = value;
        m_tail = (m_tail + 1) % m_data.size();
        ++m_size;
    }

    [[nodiscard]] ValueType pop()
    {
        if (m_size == 0) {
            throw std::underflow_error {"ring_buffer is empty"};
        }
        auto value = std::move(m_data[m_head]);
        m_head = (m_head + 1) % m_data.size();
        --m_size;
        return value;
    }

    [[nodiscard]] bool empty() const
    {
        return m_size == 0;
    }

    [[nodiscard]] std::size_t size() const
    {
        return m_size;
    }

    [[nodiscard]] std::size_t capacity() const
    {
        return m_data.size();
    }

    private:
    std::vector<ValueType> m_data;
    std::size_t m_head;
    std::size_t m_tail;
    std::size_t m_size;
};

} // namespace buffers
