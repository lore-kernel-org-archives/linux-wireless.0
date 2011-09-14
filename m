Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50013 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932610Ab1INNa1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 09:30:27 -0400
Date: Wed, 14 Sep 2011 09:27:51 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] ath9k_hw: Fix magnitude/phase coeff correction
Message-ID: <20110914132751.GA2485@tuxdriver.com> (sfid-20110914_153030_680133_3C95D2D1)
References: <1315320530-2733-1-git-send-email-rmanohar@qca.qualcomm.com>
 <20110913173226.GF11772@tuxdriver.com>
 <20110914034922.GA23349@vmraj-lnx.users.atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110914034922.GA23349@vmraj-lnx.users.atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 14, 2011 at 09:19:24AM +0530, Rajkumar Manoharan wrote:
> On Tue, Sep 13, 2011 at 01:32:26PM -0400, John W. Linville wrote:
> > On Tue, Sep 06, 2011 at 08:18:50PM +0530, Rajkumar Manoharan wrote:
> > > Do the magnitude/phase coeff correction only if the outlier
> > > is detected.
> > > 
> > > Cc: stable@kernel.org
> > > Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> > > ---
> > >  
> > >  static void ar9003_hw_tx_iqcal_load_avg_2_passes(struct ath_hw *ah,
> > 
> > What is the effect of the bug being fixed here?  Is this fix intended for 3.1?
> >
> The first entry of phase/mag got changed to average if outlier is not detected.
> This patch ensures to update appropriate index of magnitude/phase. This patch is
> applicable from 3.0 onwards.

OK, but what happens if this patch isn't applied?  Is there a crash?
Does the moon explode?  Does my beer leak through a crack in the side
of my mug?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
