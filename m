Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:7842 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbZEKBzR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 May 2009 21:55:17 -0400
Received: by ey-out-2122.google.com with SMTP id 9so819771eyd.37
        for <linux-wireless@vger.kernel.org>; Sun, 10 May 2009 18:55:17 -0700 (PDT)
Date: Mon, 11 May 2009 03:55:15 +0200
From: "Christoph .J Thompson" <cjsthompson@gmail.com>
To: Luis Correia <luis.f.correia@gmail.com>
Cc: Jon Fairbairn <jon.fairbairn@cl.cam.ac.uk>,
	linux-wireless@vger.kernel.org
Subject: Re: rt73usb Access point status
Message-Id: <20090511035515.83c21b0c.cjsthompson@gmail.com>
In-Reply-To: <efe7343f0905020334g3df47d87j31a351a878968312@mail.gmail.com>
References: <557754.25367.qm@web51403.mail.re2.yahoo.com>
	<efe7343f0904300656g127e83e1ge0b21060d6a69955@mail.gmail.com>
	<wfk54zu7t6.fsf@calligramme.charmers>
	<efe7343f0905020334g3df47d87j31a351a878968312@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2 May 2009 11:34:31 +0100
Luis Correia <luis.f.correia@gmail.com> wrote:
> No, the bug is not in hostapd.
> 
> As Johannes says, the bug is in the driver.
> Apparently, the driver is unable to get the ACK from the hardware and
> thus unable to report that ACK back to hostapd.
> 
> So the hostapd hack works, as long as there are enough room for
> retransmit supposely lost frames.
> 
> I can't explain this well enough in English, sorry.

Apparently there is no bug in neither hostapd nor the driver. From what I understood the hardware is incapable of doing it or the firmware needs to be fixed.

> To be completely honest with you in this whole AP issue, here's what I
> used to say to my friends: "if you need an AP working flawlessly under
> Linux, got with the Atheros b/g hardware".
> But that was in the madwifi days, I haven't tested it with the current
> mac80211 based driver.

But if he can't use anything else than a USB dongle than Atheros is useless. In my case I can't use anything else than a USB dongle on my AP because there's only one case you can use for this embedded board (ALIX 2d3) and it doesn't have a hole for an external antenna as it's the model with 3 ethernet ports.

-- 
Christoph .J Thompson <cjsthompson@gmail.com>
