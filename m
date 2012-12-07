Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plout10-01.prod.sin2.secureserver.net ([182.50.145.4]:54968
	"HELO sg2plout10-01.prod.sin2.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756318Ab2LGPAl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 10:00:41 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20674.1145.341426.66436@gargle.gargle.HOWL> (sfid-20121207_160044_383147_4FCB0D99)
Date: Fri, 7 Dec 2012 20:30:09 +0530
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: John Linville <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [RFC 2/8] ath9k_hw: Fix PAPRD training
In-Reply-To: <20121207102826.GB3145@hemis.qca.qualcomm.com>
References: <1354874521-4138-1-git-send-email-sujith@msujith.org>
	<1354874521-4138-3-git-send-email-sujith@msujith.org>
	<20121207102826.GB3145@hemis.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan wrote:
> > +
> > +	if (AR_SREV_9485(ah)) {
> > +		val = 148;
> > +	} else {
> > +		if (IS_CHAN_2GHZ(ah->curchan)) {
> > +			if (AR_SREV_9462(ah) || AR_SREV_9565(ah))
> > +				val = 0x91;
> Please change the hex to decimal for the sake of uniformity

Ok. :)

Sujith
