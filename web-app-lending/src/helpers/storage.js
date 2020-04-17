function parseData(data) {
  if (!data) return null
  try {
    return JSON.parse(data)
  } catch (err) {
    return data
  }
}

function stringifyData(data) {
  try {
    return JSON.stringify(data)
  } catch (err) {
    return data
  }
}

export const setItem = async (key, val) => {
  localStorage.setItem(key, stringifyData(val))
}

export const getItem = async key => {
  return parseData(localStorage.getItem(key))
}

export const clearItem = async key => {
  localStorage.removeItem(key)
}
