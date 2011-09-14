Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:60489 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753942Ab1INIp0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 04:45:26 -0400
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>, <stable@kernel.org>
Subject: Re: [PATCH] ath9k_hw: Fix magnitude/phase coeff correction
References: <1315320530-2733-1-git-send-email-rmanohar@qca.qualcomm.com>
	<20110913173226.GF11772@tuxdriver.com>
	<20110914034922.GA23349@vmraj-lnx.users.atheros.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Wed, 14 Sep 2011 11:45:20 +0300
In-Reply-To: <20110914034922.GA23349@vmraj-lnx.users.atheros.com> (Rajkumar Manoharan's message of "Wed\, 14 Sep 2011 09\:19\:24 +0530")
Message-ID: <87ehzjjyvz.fsf@purkki.adurom.net> (sfid-20110914_104529_049313_EECA8FDF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qca.qualcomm.com> writes:

> On Tue, Sep 13, 2011 at 01:32:26PM -0400, John W. Linville wrote:
>> On Tue, Sep 06, 2011 at 08:18:50PM +0530, Rajkumar Manoharan wrote:
>> > Do the magnitude/phase coeff correction only if the outlier
>> > is detected.
>> > 
>> > Cc: stable@kernel.org
>> > Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
>> > ---
>> >  
>> >  static void ar9003_hw_tx_iqcal_load_avg_2_passes(struct ath_hw *ah,
>> 
>> What is the effect of the bug being fixed here?  Is this fix intended for 3.1?
>
> The first entry of phase/mag got changed to average if outlier is
> not detected. This patch ensures to update appropriate index of
> magnitude/phase. This patch is applicable from 3.0 onwards.

Sorry, but this doesn't tell much. What's the user visible change
with this patch? Better sensitivity, less transmission errors or what?

-- 
Kalle Valo
