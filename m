Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:9017 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab2KNGaQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2012 01:30:16 -0500
Date: Wed, 14 Nov 2012 12:00:22 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Sujith Manoharan <sujith@msujith.org>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath9k_hw: Fix wrong peak detector DC offset
Message-ID: <20121114063020.GA1170@hemis.qca.qualcomm.com> (sfid-20121114_073020_456671_E9D1F068)
References: <1352452890-9512-1-git-send-email-rmanohar@qca.qualcomm.com>
 <20639.52359.988935.16158@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20639.52359.988935.16158@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 11, 2012 at 09:34:23PM +0530, Sujith Manoharan wrote:
> Rajkumar Manoharan wrote:
> > diff --git a/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h b/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
> > index 58f30f6..ccc42a7 100644
> > --- a/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
> > +++ b/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
> > @@ -78,7 +78,7 @@ static const u32 ar9462_2p0_baseband_postamble[][5] = {
> >  	{0x0000a284, 0x00000000, 0x00000000, 0x00000150, 0x00000150},
> >  	{0x0000a288, 0x00000110, 0x00000110, 0x00000110, 0x00000110},
> >  	{0x0000a28c, 0x00022222, 0x00022222, 0x00022222, 0x00022222},
> > -	{0x0000a2c4, 0x00158d18, 0x00158d18, 0x00158d18, 0x00158d18},
> > +	{0x0000a2c4, 0x00058d18, 0x00058d18, 0x00058d18, 0x00058d18},
> >  	{0x0000a2d0, 0x00041981, 0x00041981, 0x00041981, 0x00041982},
> >  	{0x0000a2d8, 0x7999a83b, 0x7999a83b, 0x7999a83b, 0x7999a83b},
> >  	{0x0000a358, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
> 
> Can you also update the initvals for AR9462 and AR9565 in the initvals tool ?

Roger that.

-Rajkumar
