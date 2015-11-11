Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:57976 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbbKKIvv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Nov 2015 03:51:51 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>,
	"open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
	devel@driverdev.osuosl.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 19/20] staging/wilc1000: use more regular probing
Date: Wed, 11 Nov 2015 09:51:38 +0100
Message-ID: <3835296.cXNgyFJAb6@wuerfel> (sfid-20151111_095210_613409_7809A10E)
In-Reply-To: <CAHp75VfpbEC0T54quQb0NV25=oCpH_1yDZnvSFdrQAe0VrnQ9g@mail.gmail.com>
References: <1447198960-2760143-1-git-send-email-arnd@arndb.de> <1447198960-2760143-20-git-send-email-arnd@arndb.de> <CAHp75VfpbEC0T54quQb0NV25=oCpH_1yDZnvSFdrQAe0VrnQ9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 11 November 2015 09:54:57 Andy Shevchenko wrote:
> > diff --git a/drivers/staging/wilc1000/linux_wlan_common.h b/drivers/staging/wilc1000/linux_wlan_common.h
> > index f2ea8280b8f8..72b524a98cba 100644
> > --- a/drivers/staging/wilc1000/linux_wlan_common.h
> > +++ b/drivers/staging/wilc1000/linux_wlan_common.h
> > @@ -38,9 +38,6 @@ enum debug_region {
> >  #define FIRM_DBG                (1 << Firmware_debug)
> >
> >  #if defined (WILC_DEBUGFS)
> 
> if this is still in use?
> Is it about DEBUG or DEBUGFS?

It's DEBUGFS, and it's currently set unconditionally by the Makefile.

	Arnd
