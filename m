Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52486 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab1HHIld (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 04:41:33 -0400
Subject: Re: IBSS channel support
From: Johannes Berg <johannes@sipsolutions.net>
To: p4u <hakais@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4E32D144.6050304@gmail.com> (sfid-20110729_172709_209159_B8526302)
References: <4E32D144.6050304@gmail.com>
	 (sfid-20110729_172709_209159_B8526302)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Aug 2011 10:41:30 +0200
Message-ID: <1312792890.4372.8.camel@jlt3.sipsolutions.net> (sfid-20110808_104136_108749_1D81F0E5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-07-29 at 17:27 +0200, p4u wrote:
> Hi,
> This is my first mail to this list, I'm Pau from Barcelona working in 
> guifi.net (wireless community)
> First of all I want to say thank you guys for your amazing job :-)
> 
> Now, I have a little question. Using command "iw phy phy0 info" I can 
> see that IBSS mode is only avaiable in some channels for 5ghz spectrum. 
> I have been looking for information about it, but I cannot find from 
> what depends if some channel can by used in IBSS mode or not. So I think 
> it depends on the driver and on the regdomain, is it right?
> 
> Also I'm working in some scripts, and I need to know if a channel has 
> IBSS support or not. The only way I found is with iw command, but pharse 
> this data is very dirty. Furthermore I can read in the end of iw help:
> 
> "Do NOT screenscrape this tool, we don't consider its output stable."
> 
> So I need another way to get this information. Any idea?

Copy bits of the wpa_supplicant or iw code into your code to get this
information. That said, iw output _should_ be fairly stable, in this
area.

johannes

