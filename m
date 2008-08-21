Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:52563 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753772AbYHUNiT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Aug 2008 09:38:19 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] ssb: Clean up extraction of MAC addresses from SPROM
Date: Thu, 21 Aug 2008 15:37:48 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <48ac9e72.4qL3A3C1AOiGC/YJ%Larry.Finger@lwfinger.net>
In-Reply-To: <48ac9e72.4qL3A3C1AOiGC/YJ%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200808211537.48800.mb@bu3sch.de> (sfid-20080821_153823_879457_65AAFCED)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 21 August 2008 00:45:06 Larry Finger wrote:
> Only rev 1 and 2 ssb SPROMs have fields named et0mac and et1mac;
> however, all of the extraction routines extract pseudo data for these
> fields from regions that are all 1's resulting in a hardware address
> of FF:FF:FF:FF:FF:FF. This patch forces such a fill at the beginning of
> the data extraction process, and only does the formal extraction if the
> SPROM rev is 1 or 2.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---

ack

-- 
Greetings Michael.
