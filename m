Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34017 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbbASMwe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2015 07:52:34 -0500
Message-ID: <1421671947.1965.27.camel@sipsolutions.net> (sfid-20150119_135237_591048_8A059639)
Subject: Re: brcmsmac: regression in transmit throughput since 3.19-rc1
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 19 Jan 2015 13:52:27 +0100
In-Reply-To: <54BBB46C.8000401@broadcom.com>
References: <54BBB46C.8000401@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

> On our nightly test setups I found that STA->AP TCP iperf showed a 
> regression in brcmsmac after I upgraded them from 3.18-rc5 
> wireless-testing (f638577)to 3.19-rc1 wireless-testing (f9e7c6c). The 
> attached pictures are historic results showing clear drop on the last run.
> 
> Has there been any report on there since 3.19-rc1 and would you have a 
> pointer on where to start looking. The changes in brcmsmac look trivial 
> so looking at mac80211 now. There are some changes in minstrel and 
> brcmsmac is using minstrel_ht rate control.

I haven't heard of anything like that yet. No idea where to look either
- but the drop is significant enough that perhaps you can bisect?

johannes

