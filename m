Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:54248 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821Ab0FYJbN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jun 2010 05:31:13 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 25 Jun 2010 02:31:13 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19492.30687.440487.157668@gargle.gargle.HOWL>
Date: Fri, 25 Jun 2010 15:03:19 +0530
To: Pavel Roskin <proski@gnu.org>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath9k_htc: Add AP mode to supported modes
In-Reply-To: <1276878831.5110.4.camel@mj>
References: <19481.60102.659111.953695@gargle.gargle.HOWL>
	<1276878831.5110.4.camel@mj>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin wrote:
> On Thu, 2010-06-17 at 14:58 +0530, Sujith wrote:
> > Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
> > ---
> >  drivers/net/wireless/ath/ath9k/htc_drv_init.c |    3 ++-
> >  drivers/net/wireless/ath/ath9k/htc_drv_main.c |    3 +++
> >  2 files changed, 5 insertions(+), 1 deletions(-)
> 
> I confirm that the AP mode is working on TP-Link TL-WN422G (0cf3:1006).
> I tested both patched of the series at once.
> 
> That's great news!  TL-WN422G has an external antenna, connects over USB
> and supports AP mode.  Users keep asking about that combination of
> features.  Now we have an answer :-)
> 

Thanks for testing, the buffering patch is a bit buggy.
Will send out updated patches doing things properly.

Sujith
