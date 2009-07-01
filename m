Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:41700 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777AbZGASSj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 14:18:39 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH V2] ssb: Add support for 4318E
Date: Wed, 1 Jul 2009 20:18:35 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <4a4ada7f.oItwGXurq7WMW+HE%Larry.Finger@lwfinger.net> <200907011517.34061.mb@bu3sch.de> <4A4B80AB.6090307@lwfinger.net>
In-Reply-To: <4A4B80AB.6090307@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200907012018.35962.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 01 July 2009 17:28:43 Larry Finger wrote:
> Michael Buesch wrote:
> > On Wednesday 01 July 2009 05:39:43 Larry Finger wrote:
> >> From: Clyde McPherson <ccmcphe@verizon.net>
> >>
> >> Added support for the Broadcom 4318E chipset on PCMCIA/CF cards. The 
> >> 4318E can do 802.11A/B/G, only B and G mode are supported in b43.
> >>
> >> Signed-off-by: Clyde McPherson <ccmcphe@verizon.net>
> >> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> > 
> > ack
> > 
> 
> Cc: Stable <stable@vger.kernel.org>

I do not think these patches are subject to -stable.

-- 
Greetings, Michael.
