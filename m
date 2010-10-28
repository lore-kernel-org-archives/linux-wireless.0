Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58217 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199Ab0J1OPK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Oct 2010 10:15:10 -0400
Date: Thu, 28 Oct 2010 10:08:07 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Chris Ball <cjb@laptop.org>
Cc: Daniel Drake <dsd@laptop.org>, dcbw@redhat.com, pgf@laptop.org,
	linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
Subject: Re: [PATCH v2] libertas: Fix sd8686 firmware reload
Message-ID: <20101028140807.GA3841@tuxdriver.com>
References: <20101027142052.9607A9D401B@zog.reactivated.net>
 <20101027195427.GB2410@tuxdriver.com>
 <20101028055704.GA16352@void.printf.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20101028055704.GA16352@void.printf.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 28, 2010 at 06:57:04AM +0100, Chris Ball wrote:
> Hi,
> 
> On Wed, Oct 27, 2010 at 03:54:27PM -0400, John W. Linville wrote:
> >   CC [M]  drivers/net/wireless/libertas/if_sdio.o
> > drivers/net/wireless/libertas/if_sdio.c: In function ‘if_sdio_prog_firmware’:
> > drivers/net/wireless/libertas/if_sdio.c:718: error: ‘IF_SDIO_MODEL_8686’ undeclared (first use in this function)
> > drivers/net/wireless/libertas/if_sdio.c:718: error: (Each undeclared identifier is reported only once
> > drivers/net/wireless/libertas/if_sdio.c:718: error: for each function it appears in.)
> > 
> > What tree has this definition?
> 
> Odd, it's been upstream in if_sdio.h since 2.6.31; mainline commit e70a5ac5.

Apparently you guys are missing 3d32a58b87cd251b50842f93b87d5458061c0cfc.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
