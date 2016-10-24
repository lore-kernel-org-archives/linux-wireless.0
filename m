Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47714 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750818AbcJXF2h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Oct 2016 01:28:37 -0400
Message-ID: <1477286912.4085.1.camel@sipsolutions.net> (sfid-20161024_072844_246040_3DA505B5)
Subject: Re: Bayesian rate control
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?Bj=F6rn?= Smedman <bjorn@openias.org>,
        linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Date: Mon, 24 Oct 2016 07:28:32 +0200
In-Reply-To: <CAGp19xcg1qCP3+JNbuiB7Hx=UjLN7KP55wVJT0sKV-iE12501A@mail.gmail.com> (sfid-20161023_160622_798535_C6DAB0EF)
References: <CAGp19xcg1qCP3+JNbuiB7Hx=UjLN7KP55wVJT0sKV-iE12501A@mail.gmail.com>
         (sfid-20161023_160622_798535_C6DAB0EF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> 1. Is there anybody else out there thinking along similar lines?

I'm not aware, but that may not mean much :)

> 2. What would be the best hardware/software stack to base this work
> on?
> 
> I'm thinking the best driver for rate control experimentation would
> be ath9k, right? If so then a TP-Link TL-WA901ND router (apparently
> based on Qualcomm QCA956x SOC) with OpenWrt, and a TP-Link TL-WDN4800 
> PCIe card (apparently based on Atheros AR9380 with PCI ID 168c:0030)
> for my desktop sounds like a good combo, no? 

Seems reasonable, yes. You wouldn't have VHT, but HT has enough search
space to keep you busy ;-)

> But would I have to run a custom kernel on my desktop then (or can I
> somehow get by with an Ubuntu standard kernel)?

You could use a backported driver. https://backports.wiki.kernel.org/

johannes
