Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-sa02.nokia.com ([147.243.1.48]:51770 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab0HWNWU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 09:22:20 -0400
Subject: Re: [PATCH 2/4] wl12xx: change contact person for the include file
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Joe Perches <joe@perches.com>
Cc: Kalle Valo <kvalo@adurom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1282507323.1879.37.camel@Joe-Laptop>
References: <20100822194615.16660.21195.stgit@potku.valot.fi>
	 <20100822194628.16660.25636.stgit@potku.valot.fi>
	 <1282507323.1879.37.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Aug 2010 16:21:57 +0300
Message-ID: <1282569717.7198.1.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2010-08-22 at 22:02 +0200, ext Joe Perches wrote:
> On Sun, 2010-08-22 at 22:46 +0300, Kalle Valo wrote:
> > Luciano should be the contact person for the include/linux/spi/wl12xx.h file.
> > diff --git a/include/linux/spi/wl12xx.h b/include/linux/spi/wl12xx.h
> > index a223ecb..a20bccf 100644
> > --- a/include/linux/spi/wl12xx.h
> > +++ b/include/linux/spi/wl12xx.h
> > @@ -3,7 +3,7 @@
> > - * Contact: Kalle Valo <kalle.valo@nokia.com>
> > + * Contact: Luciano Coelho <luciano.coelho@nokia.com>
> 
> Perhaps it's better to add that to MAINTAINERS.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---

Yes, I guess this should go to MAINTAINERS as well.

Acked-by: Luciano Coelho <luciano.coelho@nokia.com>

-- 
Cheers,
Luca.

