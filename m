Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:54758 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752477AbYIFSaG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 14:30:06 -0400
Message-ID: <48C2CC2F.1080708@lwfinger.net> (sfid-20080906_203009_882081_502B1833)
Date: Sat, 06 Sep 2008 13:30:07 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: gavron@wetwork.net
CC: Broadcom Wireless <bcm43xx-dev@berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Speed enhancement for BCM4306/2
References: <48C1BA91.7050106@lwfinger.net> <48C20928.10202@wetwork.net> <48C20BD7.6080605@lwfinger.net> <48C20F64.1000700@wetwork.net> <48C2A1F5.6020607@lwfinger.net> <48C2C6D3.3030601@wetwork.net>
In-Reply-To: <48C2C6D3.3030601@wetwork.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

gavron@wetwork.net wrote:
> I've been sitting on a git clone that refuses to proceed faster than 6 
> KiB/s (it's a problem here in Melbourne).  Should it complete I will 
> correct these issues.   I did see several other ways in which the code 
> does not match the specs.  Should that be documented in the code or 
> should the code be conformed to the specs even if that ends up breaking 
> the driver?
> 
> Without getting into specifics it's cases where the specs will say "When 
> something=value" but the code says "when variable >=(value -1)".

As Michael said, we need to see the specifics. Those specs have not 
been updated for a long time, and there are certainly errors in them. 
The only thing I can say with certainty is that in step 7 of the GPHY 
page, the specs are right and the code is wrong. That has been tested!

Larry

