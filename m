Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58100 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab1AQOBx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jan 2011 09:01:53 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTinwGaqg8ahGWd3+_dfhrCNTQNOfO1E-EUepFJ+C@mail.gmail.com>
References: <AANLkTi=GDcy50zsC6=Dgv1-Ty3cYK2qpx9o=q3JdXuCh@mail.gmail.com>
 <1295261783.24530.3.camel@maggie> <AANLkTikJcug7LUTgX_YDD4Z8ZBrdkAdLq8_Epa6TkA5f@mail.gmail.com>
 <1295265468.24530.23.camel@maggie> <AANLkTims0DPfG+u9qynuuj_-0WjUr1nAGLuFz3k706T-@mail.gmail.com>
 <AANLkTinwGaqg8ahGWd3+_dfhrCNTQNOfO1E-EUepFJ+C@mail.gmail.com>
From: Jonas Gorski <jonas.gorski@gmail.com>
Date: Mon, 17 Jan 2011 15:01:32 +0100
Message-ID: <AANLkTi=6p_bzwRtP0dOyGXGJzMg=_dQg-593Zc9BYeu0@mail.gmail.com>
Subject: Re: Merging SSB and HND/AI support
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
	linux-mips@linux-mips.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17 January 2011 14:54, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> If it's AMBA, can it be integrated with the existing code in drivers/amba/?

Hm, I once had a sentence about it there, I must have accidentally deleted it.

I tried finding similarities between Broadcom's code and ARM's AMBA
specification to better understand the code, but except some tiny ones
I couldn't find anything usable. Unfortunately I couldn't find
anything about Broadcom's AMBA implementation, except that it's "AMBA"
licensed from ARM.

Jonas
