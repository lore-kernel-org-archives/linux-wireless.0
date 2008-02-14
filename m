Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:32769 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092AbYBNQpm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2008 11:45:42 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Wi-Fi interface intermittently missing on HP laptop
Date: Thu, 14 Feb 2008 17:45:19 +0100
Cc: Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
References: <47B46E36.3050206@lwfinger.net>
In-Reply-To: <47B46E36.3050206@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200802141745.19454.mb@bu3sch.de> (sfid-20080214_164545_878782_D079E92D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 14 February 2008 17:37:10 Larry Finger wrote:
> The BCM94311 interface on my HP dv2125nr is intermittent. Twice (so far) it has gone missing and
> will not show up when the PCI subsystem is interrogated using lspci. It is hardware because Windows
> doesn't find it either.
> 
> I remember seeing reports of this problem on mailing lists. If your computer has suffered from this
> error, please let me know what it took to fix it. I suspect a motherboard problem, and would like to
> know other's experiences when I try to get mine fixed under warranty.

some broadcom chips have problems with some PCI signals.
I also saw stuff like that. Usually pulling and putting back the card helps.
I have a b44 card which doesn't work in a PCI extender, because of some signal
sensing being too low. The additional 10cm of wire added by the extender will
make it fail then. This also depends on the motherboard's signal strength.

-- 
Greetings Michael.
