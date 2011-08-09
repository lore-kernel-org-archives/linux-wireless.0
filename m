Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50386 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab1HIUAO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 16:00:14 -0400
Date: Tue, 9 Aug 2011 15:51:03 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH v2 08/13] ath9k_hw: Fix incorrect Tx control power in
 AR9003 template
Message-ID: <20110809195103.GE10077@tuxdriver.com> (sfid-20110809_220018_769386_8885ED80)
References: <1311941300-2590-1-git-send-email-rmanohar@qca.qualcomm.com>
 <1311941300-2590-8-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1311941300-2590-8-git-send-email-rmanohar@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 29, 2011 at 05:38:15PM +0530, Rajkumar Manoharan wrote:
> CTL power data incorrect in ctlPowerData_2G field of ar9300_eeprom.
> Setting incorrect CTL power in calibration is causing lower tx power.
> Tx power was reported as 3dBm while operating in channel 6 HT40+/
> in channel 11 HT40- due to CTL powers in the calibration is set to
> zero.
> 
> Cc: stable@kernel.org
> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>

Please post fixes (particular those that are Cc: stable@kernel.org)
as separate patch series.

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
