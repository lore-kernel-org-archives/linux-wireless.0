Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:34368 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab1AVD4M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 22:56:12 -0500
Received: by qwa26 with SMTP id 26so2462464qwa.19
        for <linux-wireless@vger.kernel.org>; Fri, 21 Jan 2011 19:56:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTimG1e3UQo9LW42FNh2OewPJ8xAhGvao6-jc2FGF@mail.gmail.com>
References: <1295654809-5790-1-git-send-email-wey-yi.w.guy@intel.com>
 <1295654809-5790-5-git-send-email-wey-yi.w.guy@intel.com> <AANLkTinqZ-7E943Qd8swN0hS5XFaSeayBm75Lkz768Bv@mail.gmail.com>
 <AANLkTik11iCqMF+pRYX7jvzj03t_cTCZh1ivb1Tt3L01@mail.gmail.com>
 <AANLkTimf-GodWmUqbJkCiP_BPChAT60oQ0ZVTRq_0p73@mail.gmail.com>
 <AANLkTimqmEYWpV89+cUebvV0Ai-2vobmVY5tiO5R8cOa@mail.gmail.com> <AANLkTimG1e3UQo9LW42FNh2OewPJ8xAhGvao6-jc2FGF@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sat, 22 Jan 2011 04:55:51 +0100
Message-ID: <AANLkTim6GbW_7eF5NJXqemZ47AQguhHvfhsTMSq6oiTx@mail.gmail.com>
Subject: Re: [ipw3945-devel] [PATCH 04/14] iwlagn: 2000 series devices support
To: Daniel Halperin <dhalperi@cs.washington.edu>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/1/22 Daniel Halperin <dhalperi@cs.washington.edu>:
> 2011/1/21 Gábor Stefanik <netrolller.3d@gmail.com>:
>> 2011/1/22 Gábor Stefanik <netrolller.3d@gmail.com>:
>>>> about the market, how many 3-stream APs can you buy today?
>>>
>>> Well, there is the Airport Extreme, the D-Link DIR-665 (with a
>>> Marvell-chipped mini-PCI card inside), and also an offering from
>>> Senao
>
> Wow, seriously, thanks for the list!  I had no idea Apple added 3
> streams to the Airport Extreme (the first gen and the first dual-band
> one didn't have it); the only place i could find it was in the WFA
> certificate.  I also didn't know that D-Link made a plausibly useful
> dual-band AP.  That's awesome.
>
> Still, that's 3 out of 325 of the 802.11n APs on the WFA certified
> list.  Okay, let's say there's 10 more that neither of us mentioned,
> that's still maximum 3%, or say 5%.  And they all cost around $200.
> For one randomly-selected (well, selected from their "Value-priced"
> category) example, D-link's DIR-515 costs $38.
>
> A possibly silly, possibly illuminating question here: is there
> anything *WRONG* with the 6300?  Is there a reason you're looking for
> a new iteration?  What might be funny is that Wi-Fi, unlike CPU,
> doesn't really get that much better over the years (as long as you
> stick to the standard).  And the newest, most exciting stuff -- e.g.,
> Wi-Di -- works with the 6300.

I'm not really referring to the 6300 - I'm talking about what the 6350
would have been, true 3-stream 802.11n + WiMax. The 5350 had only
partial WiMax implementation, and even that is gone now that the 5350
has been discontinued. Also, if they could pull off 3-stream+WiMax,
and they are doing 2-stream+Bluetooth 3.0 now, I'm pretty sure
3-stream+BT3.0 would be doable.

>
> Why might you want a new version?  Lower cost? -- the chips already
> cost like $30, that's pretty cheap, say Intel could bring it down to
> $25 would that increase volume enough to make it worth while?  I doubt
> it.  To save power? -- well, 6300 is a pretty feature-rich chip, it
> probably goes in devices like fancy laptops where it isn't a
> relatively large power drain, and pretty efficient use will come from
> Wi-Fi sleep modes.  Power efficiency matters more when Wi-Fi is a
> relatively large contributor to power draw.  Oh wait, that's in the
> small devices that only want 1x1 or 1x2, so maybe it IS worth Intel's
> time/money to keep revving those chips every time they can use a
> smaller process.

Well, power efficiency does make sense for higher-end devices too -
expect that instead of lowering consumption, it should go into higher
TX power at the same consumption level. AFAIK both the 5xxx and 6xxx
series are capped @ 15dBm, while regulatory allows at least 20dBm, and
even more than that in some places.

Also, by creating lots of different non-3-stream devices, Intel is
indirectly discouraging OEMs from using 3-stream technology (because
there is only one 3-stream offering, the 6300, while in the 1- and
2-stream category, there are lots of different designs with different
bells and whistles each). While they did innovate in the high-end
range with the 5300 and the 6300, they went *backwards* in the
mainstream - remember how the 4965 was 3x3:2x2 (antennas/streams),
while its mainstream successor, the 5100, was 1x2:1x2 - 50% upstream
performance loss, plus losing all the benefits of extra antenna
diversity. Even the 6200 is only 2x2:2x2, still weaker than the 4965.

>
> I don't know anything about Intel's internal plans, and this is all my
> own speculation, but ... I'd love to hear what it is you'd like the
> new chip to have that the current ones don't.  Certainly, no one's
> asking for them to rev the 3945, and I think for good reason. ;).
>
> Dan
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
