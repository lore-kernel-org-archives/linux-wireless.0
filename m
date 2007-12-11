Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:39285 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbXLKPZG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2007 10:25:06 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Stefano Brivio <stefano.brivio@polimi.it>
Subject: Re: [PATCH RFT] b43: Fix for broken transmission
Date: Tue, 11 Dec 2007 16:22:53 +0100
Cc: John Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de,
	Johannes Berg <johannes@sipsolutions.net>,
	Joseph Jezak <josejx@gentoo.org>,
	linux-wireless@vger.kernel.org
References: <200712111343.50943.mb@bu3sch.de>
In-Reply-To: <200712111343.50943.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200712111622.54086.mb@bu3sch.de> (sfid-20071211_152511_069818_7E7ED342)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 11 December 2007 13:43:50 Michael Buesch wrote:
> This patch fixes the transmission problems introduced by
> commit f04b3787bbce4567e28069a9ec97dcd804626ac7
> 
> It depends on
> [PATCH] b43: Fix ofdmtab write regression
> 
> I'm not sure if the dummy read is really required.
> The old code does it. I think it can't hurt and can possibly
> fix some write posting problems (hardware bugs or whatever. Who knows).
> 
> Please test this.
> 
> NOT-signed-off-by: Michael Buesch <mb@bu3sch.de>

Here's an updated version that should fix even more bugs:
http://bu3sch.de/patches/wireless-2.6/20071211-1622/patches/005-b43-fix-init-rewrite-breakage.patch

-- 
Greetings Michael.
