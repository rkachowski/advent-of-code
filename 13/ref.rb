class Cart
    attr_accessor :x, :y, :xv, :yv, :t, :alive
    def initialize x, y, xv, yv
        @x = x
        @y = y
        @xv = xv
        @yv = yv
        @t = 0
        @alive = true
    end
end

ca = []
d = File.readlines('input').map.with_index do |line,y|
    line.chomp.chars.map.with_index do |c,x|
        case c
        when ?< then ca.push Cart.new(x,y,-1,0); ?-
        when ?> then ca.push Cart.new(x,y, 1,0); ?-
        when ?^ then ca.push Cart.new(x,y,0,-1); ?|
        when ?v then ca.push Cart.new(x,y,0, 1); ?|
        else c
        end
    end
end

loop {
    ca.sort_by!{|c| c.y*99999+c.x}
    ca.each do |c|
        next unless c.alive

        cx = c.x + c.xv
        cy = c.y + c.yv
        crash = ca.find{|c2| c2.x == cx && c2.y == cy && c2.alive}
        if crash
            c.alive = false
            crash.alive = false
            asf = ca.select{|asdf|asdf.alive}
            if asf.size == 1
                p asf[0].x
                p asf[0].y
                exit
            end
            next
        end
        c.x = cx
        c.y = cy

        case d[c.y][c.x]
        when '\\' then c.xv, c.yv = c.yv, c.xv
        when '/' then c.xv, c.yv = -c.yv, -c.xv
        when '+'
            case c.t
            when 0 then c.xv, c.yv = c.yv, -c.xv
            when 1 #nop
            when 2 then c.xv, c.yv = -c.yv, c.xv
            end
            c.t = (c.t+1)%3
        end

    end
}
