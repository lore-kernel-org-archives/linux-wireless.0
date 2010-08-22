Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:1213 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093Ab0HVUCG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Aug 2010 16:02:06 -0400
Subject: Re: [PATCH 2/4] wl12xx: change contact person for the include file
From: Joe Perches <joe@perches.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@nokia.com>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20100822194628.16660.25636.stgit@potku.valot.fi>
References: <20100822194615.16660.21195.stgit@potku.valot.fi>
	 <20100822194628.16660.25636.stgit@potku.valot.fi>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 22 Aug 2010 13:02:03 -0700
Message-ID: <1282507323.1879.37.camel@Joe-Laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2010-08-22 at 22:46 +0300, Kalle Valo wrote:
> Luciano should be the contact person for the include/linux/spi/wl12xx.h file.
> diff --git a/include/linux/spi/wl12xx.h b/include/linux/spi/wl12xx.h
> index a223ecb..a20bccf 100644
> --- a/include/linux/spi/wl12xx.h
> +++ b/include/linux/spi/wl12xx.h
> @@ -3,7 +3,7 @@
> - * Contact: Kalle Valo <kalle.valo@nokia.com>
> + * Contact: Luciano Coelho <luciano.coelho@nokia.com>

Perhaps it's better to add that to MAINTAINERS.

Signed-off-by: Joe Perches <joe@perches.com>
---
diff --git a/MAINTAINERS b/MAINTAINERS
index 433f353..dc43e8f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6384,6 +6384,7 @@ W:	http://wireless.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
 S:	Maintained
 F:	drivers/net/wireless/wl12xx/wl1271*
+F:	include/linux/spi/wl12xx.h
 
 WL3501 WIRELESS PCMCIA CARD DRIVER
 M:	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>


