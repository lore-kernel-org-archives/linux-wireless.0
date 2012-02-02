Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27642 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023Ab2BBD4l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Feb 2012 22:56:41 -0500
Date: Thu, 2 Feb 2012 09:26:54 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	Paul Stewart <pstew@google.com>
Subject: Re: [PATCH 1/2] ath9k: recover the chip from tx/rx stuck
Message-ID: <20120202035652.GB25988@vmraj-lnx.users.atheros.com> (sfid-20120202_045646_054330_A11FF6BE)
References: <1328112335-19265-1-git-send-email-rmanohar@qca.qualcomm.com>
 <20265.65072.546108.448327@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20265.65072.546108.448327@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 02, 2012 at 08:38:32AM +0530, Sujith Manoharan wrote:
> Rajkumar Manoharan wrote:
> > +void ath_start_rx_poll(struct ath_softc *sc, const u32 msec)
> > +{
> > +	if (!AR_SREV_9300_20_OR_LATER(sc->sc_ah))
> > +		return;
> 
> I have not reviewed the patch, but to do such workarounds for an entire
> family of chips is overkill. Has it been confirmed that the other
> chips falling under this SREV check require this snafu ?
>
unfortunately this snafu is applicable for all ar9380 MAC based chips ;)
and confirmed the same.

--
Rajkumar
