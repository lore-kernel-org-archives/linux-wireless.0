Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:56754 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750706AbZAXFE6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2009 00:04:58 -0500
Message-ID: <497AA16F.30409@lwfinger.net> (sfid-20090124_060513_712816_24F6184F)
Date: Fri, 23 Jan 2009 23:04:47 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: linville@tuxdriver.com, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: Automatically probe for opensource firmware
References: <200901232121.52012.mb@bu3sch.de>
In-Reply-To: <200901232121.52012.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> First probe for proprietary firmware and then probe for opensource firmware.
> This way around it's a win-win situation.
> 1) If proprietary fw is available, it will work.
> 2) If opensource firmware is available, but no proprietary (Distros can only ship open fw)
>    it might work.
> 3) If both open and proprietary are available, it will work, because it selects
>    the proprietary. We currently don't prefer the open fw in this case, because it doesn't
>    work on all devices. It would introduce a regression otherwise.
> 
> The remaining FIXMEs in this patch are harmless, because they only matter on multiband
> devices, which are not implemented yet anyway.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
> 
> ---
> 
> John, please queue for the next feature round.

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

I made one temporary change to search for open-source firmware before
the proprietary version because I boot kernels that are not changed to
handle the o-s version, but still want to test when I can.

I understand and approve of your logic - it just doesn't fit my
current agenda.

Larry
