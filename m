Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61145 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754720Ab1AVDIO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 22:08:14 -0500
Received: by iwn9 with SMTP id 9so2319375iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 21 Jan 2011 19:08:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTimqmEYWpV89+cUebvV0Ai-2vobmVY5tiO5R8cOa@mail.gmail.com>
References: <1295654809-5790-1-git-send-email-wey-yi.w.guy@intel.com>
 <1295654809-5790-5-git-send-email-wey-yi.w.guy@intel.com> <AANLkTinqZ-7E943Qd8swN0hS5XFaSeayBm75Lkz768Bv@mail.gmail.com>
 <AANLkTik11iCqMF+pRYX7jvzj03t_cTCZh1ivb1Tt3L01@mail.gmail.com>
 <AANLkTimf-GodWmUqbJkCiP_BPChAT60oQ0ZVTRq_0p73@mail.gmail.com> <AANLkTimqmEYWpV89+cUebvV0Ai-2vobmVY5tiO5R8cOa@mail.gmail.com>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Fri, 21 Jan 2011 19:07:53 -0800
Message-ID: <AANLkTimG1e3UQo9LW42FNh2OewPJ8xAhGvao6-jc2FGF@mail.gmail.com>
Subject: Re: [ipw3945-devel] [PATCH 04/14] iwlagn: 2000 series devices support
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/1/21 Gábor Stefanik <netrolller.3d@gmail.com>:
> 2011/1/22 Gábor Stefanik <netrolller.3d@gmail.com>:
>>> about the market, how many 3-stream APs can you buy today?
>>
>> Well, there is the Airport Extreme, the D-Link DIR-665 (with a
>> Marvell-chipped mini-PCI card inside), and also an offering from
>> Senao

Wow, seriously, thanks for the list!  I had no idea Apple added 3
streams to the Airport Extreme (the first gen and the first dual-band
one didn't have it); the only place i could find it was in the WFA
certificate.  I also didn't know that D-Link made a plausibly useful
dual-band AP.  That's awesome.

Still, that's 3 out of 325 of the 802.11n APs on the WFA certified
list.  Okay, let's say there's 10 more that neither of us mentioned,
that's still maximum 3%, or say 5%.  And they all cost around $200.
For one randomly-selected (well, selected from their "Value-priced"
category) example, D-link's DIR-515 costs $38.

A possibly silly, possibly illuminating question here: is there
anything *WRONG* with the 6300?  Is there a reason you're looking for
a new iteration?  What might be funny is that Wi-Fi, unlike CPU,
doesn't really get that much better over the years (as long as you
stick to the standard).  And the newest, most exciting stuff -- e.g.,
Wi-Di -- works with the 6300.

Why might you want a new version?  Lower cost? -- the chips already
cost like $30, that's pretty cheap, say Intel could bring it down to
$25 would that increase volume enough to make it worth while?  I doubt
it.  To save power? -- well, 6300 is a pretty feature-rich chip, it
probably goes in devices like fancy laptops where it isn't a
relatively large power drain, and pretty efficient use will come from
Wi-Fi sleep modes.  Power efficiency matters more when Wi-Fi is a
relatively large contributor to power draw.  Oh wait, that's in the
small devices that only want 1x1 or 1x2, so maybe it IS worth Intel's
time/money to keep revving those chips every time they can use a
smaller process.

I don't know anything about Intel's internal plans, and this is all my
own speculation, but ... I'd love to hear what it is you'd like the
new chip to have that the current ones don't.  Certainly, no one's
asking for them to rev the 3945, and I think for good reason. ;).

Dan
