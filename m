Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plsmtpa01-01.prod.sin2.secureserver.net ([182.50.145.6]:37816
	"EHLO sg2plsmtpa01-01.prod.sin2.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753747Ab3AGJPB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jan 2013 04:15:01 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20714.37343.179567.208457@gargle.gargle.HOWL> (sfid-20130107_101506_785302_18D9EA78)
Date: Mon, 7 Jan 2013 14:44:07 +0530
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: John Linville <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/3] ath9k_hw: Use helper routines to simplify
 ar9003_hw_init_cal()
In-Reply-To: <20130107090244.GA1127@hemis.qca.qualcomm.com>
References: <1357547028-22891-1-git-send-email-sujith@msujith.org>
	<1357547028-22891-3-git-send-email-sujith@msujith.org>
	<20130107090244.GA1127@hemis.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan wrote:
> > +static void ar9003_hw_do_manual_peak_cal(struct ath_hw *ah,
> > +					 struct ath9k_channel *chan)
> > +{
> > +	int i;
> > +
> > +	if (!AR_SREV_9462(ah) || !AR_SREV_9565(ah))
> > +		return;
> > +
> It should be && not ||

Thanks, I've sent a v2.

Sujith
