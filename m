Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55256 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755279AbbJAHs3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2015 03:48:29 -0400
Message-ID: <1443685705.1880.6.camel@sipsolutions.net> (sfid-20151001_094856_803813_6500FC81)
Subject: Re: Rate limiting AP bandwidth change messages in
 ieee80211_config_bw?
From: Johannes Berg <johannes@sipsolutions.net>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: drago01 <drago01@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>,
	"Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Date: Thu, 01 Oct 2015 09:48:25 +0200
In-Reply-To: <CA+5PVA5L2LwwbJmoxwkYtJ=PYc9Q5g4KpqwmA0urxX8CRe=L+g@mail.gmail.com> (sfid-20151001_020951_577334_ECF74B43)
References: <CA+5PVA4yaLG2NtJ_Bg5-BQzR-Wa5ABxPb-cLxF7bjSsf-P1_5Q@mail.gmail.com>
	 <1443637937.1859.19.camel@sipsolutions.net>
	 <1443639852.1859.25.camel@sipsolutions.net>
	 <CA+5PVA5L2LwwbJmoxwkYtJ=PYc9Q5g4KpqwmA0urxX8CRe=L+g@mail.gmail.com>
	 (sfid-20151001_020951_577334_ECF74B43)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> For what purpose?  Or rather, when a user sees this in their dmesg,
> what are they supposed to do about it?

I think the idea isn't that the user would do something, but more that
in case of performance issues, or perhaps driver/device bugs handling
the changes, or similar you'd have an indication that this happened.


> > perhaps we should try rate limiting it then? Could you check if 
> > that
> > actually works?
> 
> I'll think on it, sure.  I was hoping sdata_dbg would be sufficient
> because it's much easier, but if there's value in the message I can
> look at limiting it in some fashion.
> 

Thanks.

johannes
