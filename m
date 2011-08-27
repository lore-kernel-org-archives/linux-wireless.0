Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:42578 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab1H0Gw3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Aug 2011 02:52:29 -0400
Date: Sat, 27 Aug 2011 12:22:57 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath9k_hw: Set default slottime as 9us
Message-ID: <20110827065256.GA3082@vmraj-lnx.users.atheros.com> (sfid-20110827_085236_471113_85DA8CF5)
References: <1314424379-1206-1-git-send-email-rmanohar@qca.qualcomm.com>
 <4E588E3B.9000007@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4E588E3B.9000007@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 27, 2011 at 08:27:07AM +0200, Felix Fietkau wrote:
> On 2011-08-27 7:52 AM, Rajkumar Manoharan wrote:
> >Initialize 9us slot time as that is what is used mostly
> >(for non-ERP cases) and also to be in sync with initvals.
> >
> >Signed-off-by: Rajkumar Manoharan<rmanohar@qca.qualcomm.com>
> Why does it matter, mac80211 tells the driver to reconfigure it
> anyway. Also, why use the stupid ATH9K_SLOT_TIME_* enums? I think we
> should simply remove those.
>
In most of the case, mac80211 set as 9us and also initval uses 9us.
The what is the problem of setting 9us as default. If you want to
remove ATH9K_SLOT_TIME_* enums, ath9k should not set slottime till
it got configured.

--
Rajkumar
