Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693Ab1G2Pu0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jul 2011 11:50:26 -0400
Subject: Re: IBSS channel support
From: Dan Williams <dcbw@redhat.com>
To: p4u <hakais@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 29 Jul 2011 10:54:33 -0500
In-Reply-To: <4E32D144.6050304@gmail.com>
References: <4E32D144.6050304@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1311954873.3084.2.camel@dcbw.foobar.com> (sfid-20110729_175030_072145_BD0D5FD6)
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

Yes.

> Also I'm working in some scripts, and I need to know if a channel has 
> IBSS support or not. The only way I found is with iw command, but pharse 
> this data is very dirty. Furthermore I can read in the end of iw help:
> 
> "Do NOT screenscrape this tool, we don't consider its output stable."
> 
> So I need another way to get this information. Any idea?

Couldn't you use the CRDA database?  That's got bits that indicate
whether or not some channels allow IBSS in your domain or not.

http://wireless.kernel.org/download/wireless-regdb/

Dan


