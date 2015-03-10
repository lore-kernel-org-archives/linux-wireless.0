Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31905 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632AbbCJPo1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2015 11:44:27 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] ath10k: add sysfs entry to configure quiet period
References: <1424437452-28161-1-git-send-email-rmanohar@qti.qualcomm.com>
Date: Tue, 10 Mar 2015 17:43:58 +0200
In-Reply-To: <1424437452-28161-1-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Fri, 20 Feb 2015 18:34:10 +0530")
Message-ID: <87lhj4yi0x.fsf@kamboji.qca.qualcomm.com> (sfid-20150310_164502_049261_DEF9E5C9)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> Add support to configure quiet period via sysfs entry. This will
> be helpful to experiment different quiet period values along with
> different duty cycle ratio.
>
> To configure quiet period as 30ms,
>
> echo 30 >/sys/class/ieee80211/phyX/device/quiet_period

What's the justification? To me this looks like an ugly driver private
hack. Why can't you use nl80211 or something else?

-- 
Kalle Valo
