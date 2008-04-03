Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:35444 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757471AbYDCPkg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 11:40:36 -0400
From: Chr <chunkeey@web.de>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [RFC][PATCH 0/4] p54: various updates
Date: Thu, 3 Apr 2008 17:40:32 +0200
Cc: linux-wireless@vger.kernel.org,
	"Michael Wu" <flamingice@sourmilk.net>,
	John Linville <linville@tuxdriver.com>
References: <200804012339.37204.chunkeey@web.de> <43e72e890804021642u4dd7b329w60344c991e2a7e43@mail.gmail.com>
In-Reply-To: <43e72e890804021642u4dd7b329w60344c991e2a7e43@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200804031740.33177.chunkeey@web.de> (sfid-20080403_164051_477031_3427BCFA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 03 April 2008 01:42:59 Luis R. Rodriguez wrote:
>
> Thanks, can you resend as inline patches so it can help get better
> review. Also while you're at it can you stuff all p54 files into its
> own folder?
hmm, I can.... but:
- in which folder? for now.. I put everything into a new one folder named p54,
  but as you know the fullmac driver has already the prism54 subdirectory...
  should I put it there? or is this confusing?  

- the resulting patch is too big to post it here, ~ 271kb as plaintext...
  is a bz2 (32kb)  attachment ok too?

diffstat:
 b/drivers/net/wireless/Kconfig         |   65 --
 b/drivers/net/wireless/Makefile        |    4
 b/drivers/net/wireless/p54/Kconfig     |   63 +
 b/drivers/net/wireless/p54/Makefile    |    3
 b/drivers/net/wireless/p54/net2280.h   |  452 ++++++++++++++
 b/drivers/net/wireless/p54/p54.h       |   77 ++
 b/drivers/net/wireless/p54/p54common.c | 1051 
+++++++++++++++++++++++++++++++++
 b/drivers/net/wireless/p54/p54common.h |  254 +++++++
 b/drivers/net/wireless/p54/p54pci.c    |  697 +++++++++++++++++++++
 b/drivers/net/wireless/p54/p54pci.h    |  106 +++
 b/drivers/net/wireless/p54/p54usb.c    |  910 ++++++++++++++++++++++++++++
 b/drivers/net/wireless/p54/p54usb.h    |  133 ++++
 drivers/net/wireless/net2280.h         |  452 --------------
 drivers/net/wireless/p54.h             |   77 --
 drivers/net/wireless/p54common.c       | 
1051 ---------------------------------
 drivers/net/wireless/p54common.h       |  254 -------
 drivers/net/wireless/p54pci.c          |  697 ---------------------
 drivers/net/wireless/p54pci.h          |  106 ---
 drivers/net/wireless/p54usb.c          |  910 ----------------------------
 drivers/net/wireless/p54usb.h          |  133 ----
 20 files changed, 3748 insertions(+), 3747 deletions(-)

 Regards,
	Chr
