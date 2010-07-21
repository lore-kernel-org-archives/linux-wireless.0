Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47408 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670Ab0GUNpP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jul 2010 09:45:15 -0400
Date: Wed, 21 Jul 2010 09:33:20 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Pauli Nieminen <suokkos@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8180: improve signal reporting for rtl8185 hardware
Message-ID: <20100721133320.GB2355@tuxdriver.com>
References: <AANLkTiknLRzt2bdhcin5WRzwPXSWqEs8dIUe5imlN0I9@mail.gmail.com>
 <1279572443-14361-1-git-send-email-linville@tuxdriver.com>
 <AANLkTino_4FKtMWZU7_lKGzPUXNOtfrmlw_rmmr836eA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <AANLkTino_4FKtMWZU7_lKGzPUXNOtfrmlw_rmmr836eA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 21, 2010 at 08:08:41AM +0300, Pauli Nieminen wrote:
> On Mon, Jul 19, 2010 at 11:47 PM, John W. Linville
> <linville@tuxdriver.com> wrote:
> > The existing code seemed to be somewhat based on the datasheet, but
> > varied substantially from the vendor-provided driver.  This mirrors the
> > handling of the rtl8185 case from that driver, but still neglects the
> > specifics for the rtl8180 hardware.  Those details are a bit muddled...
> >
> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
> > ---
> >  drivers/net/wireless/rtl818x/rtl8180_dev.c |   11 ++++++++---
> >  1 files changed, 8 insertions(+), 3 deletions(-)

> I tested this version of patch. Patch didn't apply cleanly for some
> reason even tough when I mnauly typed it diff looks same.

Please try the v2 version of the patch.  Some "back of the envelope"
math suggests that the v2 version of the patch will give numbers more
to your liking.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
