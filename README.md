-- โหลด Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/naris291977-arch/Ui.lua/refs/heads/main/Yu.lua"))()

-- สร้างหน้าต่าง
local Window = Library:CreateWindow({
    Name = "PEPE HUB",
    Version = "V5.0"
})

-- =========================
-- TAB 1
-- =========================

local Main = Window:CreateTab({
    Name = "หน้าหลัก",
    Icon = "🏠"
})

Main:CreateSection("ระบบทั่วไป")

Main:CreateParagraph({
    Title = "ยินดีต้อนรับ",
    Content = "นี่คือตัวอย่างการใช้งาน PEPE UI Library"
})

Main:CreateButton({
    Name = "🔔 แจ้งเตือน",

    Callback = function()

        Library:Notify({
            Title = "PEPE HUB",
            Content = "ปุ่มทำงานแล้ว!",
            Duration = 3
        })

    end
})

Main:CreateToggle({
    Name = "⚡ เปิดระบบ",

    CurrentValue = false,

    Callback = function(Value)

        print("ระบบ:", Value)

    end
})

Main:CreateSlider({
    Name = "ความเร็ว",

    Range = {1, 100},
    Increment = 1,
    CurrentValue = 50,

    Callback = function(Value)

        print("ความเร็ว:", Value)

    end
})

Main:CreateDropdown({
    Name = "เลือกโหมด",

    Options = {
        "ปกติ",
        "เร็ว",
        "แรง"
    },

    CurrentOption = "ปกติ",

    Callback = function(Value)

        print("เลือก:", Value)

    end
})

-- =========================
-- TAB 2
-- =========================

local Settings = Window:CreateTab({
    Name = "ตั้งค่า",
    Icon = "⚙️"
})

Settings:CreateSection("Appearance")

Settings:CreateColorPicker({
    Name = "เปลี่ยนสี UI",

    Color = Color3.fromRGB(126, 92, 255),

    Callback = function(Color)

        print("สีใหม่:", Color)

    end
})

Settings:CreateInput({
    PlaceholderText = "พิมพ์ข้อความ...",

    Callback = function(Text)

        print("ข้อความ:", Text)

    end
})

Settings:CreateDivider()

Settings:CreateButton({
    Name = "📱 ทดสอบ Mobile",

    Callback = function()

        Library:Notify({
            Title = "Mobile",
            Content = "ระบบ Mobile พร้อมใช้งาน",
            Duration = 2
        })

    end
})