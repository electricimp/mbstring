// Copyright (c) 2014 Electric Imp
// This file is licensed under the MIT License
// http://opensource.org/licenses/MIT

class mbstring
{
    static version = [1, 0, 0]
    
    _str = null
    
    constructor(str = "")
    {
        _str = []
        
        switch (typeof str)
        {
            case "string":
            case "blob":
                break
            case "integer":
                str = format("%d", str)
                break
            case "float":
                str = format("%f", str)
                break
            case "mbstring":
            case "array":
                foreach (ch in str)
                {
                    _str.push(ch)
                }
                return
            default:
                throw format("Can't convert from '%s' to mbstring", typeof str)
        }
        
        for (local i = 0 ; i < str.len() ; i++)
        {
            local ch1 = (str[i] & 0xFF)
            if ((ch1 & 0x80) == 0x00)
            {
                // 0xxxxxxx = 7-bit Ascii
                _str.push(format("%c", ch1))
            } 
            else if ((ch1 & 0xE0) == 0xC0)
            {
                // 110xxxxx = 2-byte unicode
                local ch2 = (str[++i] & 0xFF)
                _str.push(format("%c%c", ch1, ch2))
            } 
            else if ((ch1 & 0xF0) == 0xE0)
            {
                // 1110xxxx = 3-byte unicode
                local ch2 = (str[++i] & 0xFF)
                local ch3 = (str[++i] & 0xFF)
                _str.push(format("%c%c%c", ch1, ch2, ch3))
            } 
            else if ((ch1 & 0xF8) == 0xF0)
            {
                // 11110xxx = 4 byte unicode
                local ch2 = (str[++i] & 0xFF)
                local ch3 = (str[++i] & 0xFF)
                local ch4 = (str[++i] & 0xFF)
                _str.push(format("%c%c%c%c", ch1, ch2, ch3, ch4))
            }
        }
    }
    
    function _typeof()
    {
        return "mbstring"
    }
    
    function _add(op)
    {
        local new_str = mbstring(_str)
        foreach (ch in op)
        {
            new_str._str.push(ch)
        }
        return new_str
    }
    
    function _cmp(other)
    {
        for (local i = 0; i < _str.len(); i++)
        {
            if (i < other._str.len())
            {
                local ch1 = _str[i]
                local ch2 = other._str[i]
                if (ch1 > ch2) return 1
                else if (ch1 < ch2) return -1
            }
        }
        return _str.len() <=> other.len()
    }
    
    function _nexti(previdx)
    {
        if (_str.len() == 0) return null
        else if (previdx == null) return 0
        else if (previdx == _str.len()-1) return null
        else return previdx + 1
    }
    
    function _get(idx)
    {
        if (typeof idx == "integer")
        {
            return _str[idx]
        } 
        else 
        {
            return ::getroottable()[idx]
        }
    }
    
    function _set(idx, val)
    {
        throw "mbstrings are immutable"
    }
    
    function _tostring()
    {
        local str = ""
        foreach (ch in _str)
        {
            str += ch
        }
        return str
    }

    function tointeger()
    {
        return _tostring().tointeger()
    }
    
    function tofloat() 
    {
        return _tostring().tofloat()
    }
    
    function tostring()
    {
        return _tostring()
    }
    
    function len() 
    {
        return _str.len()
    }
    
    function slice(start, end = null)
    {
        local sliced = null
        if (end == null) 
        {
        	sliced = _str.slice(start)
        }
        else
        {
        	sliced = _str.slice(start, end)
        }
        return mbstring(sliced)
    }
    
    function find(substr, startidx = null)
    {
        if (typeof substr != "mbstring")
        {
            substr = mbstring(substr)
        }
        if (startidx == null)
        {
        	startidx = 0
        }
        else if (startidx < 0)
        {
        	startidx = _str.len() + startidx
        }
        local match = null
        local length = null
        for (local i = startidx ; i < _str.len() && i+substr.len() <= _str.len() ; i++)
        {
            match = i
            length = null
            for (local j = 0 ; j < substr.len() && i+j < _str.len() ; j++)
            {
                if (_str[i+j] != substr[j]) break
                length = j + 1
            }

            if (match != null && length == substr.len()) return match;
        }
        return null
    }
}
