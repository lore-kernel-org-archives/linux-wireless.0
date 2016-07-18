Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52118 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbcGRQZX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2016 12:25:23 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
Cc: <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>,
	<jouni@qca.qualcomm.com>, <usdutt@qti.qualcomm.com>,
	<ganeshk@qti.qualcomm.com>, <mkalikot@qca.qualcomm.com>,
	<amarnath@qca.qualcomm.com>
Subject: Re: [PATCH v2] cfg80211: Allow differnt beacon interval if driver supports
References: <1468849985-6881-1-git-send-email-pkushwah@qti.qualcomm.com>
Date: Mon, 18 Jul 2016 19:25:16 +0300
In-Reply-To: <1468849985-6881-1-git-send-email-pkushwah@qti.qualcomm.com>
	(Purushottam Kushwaha's message of "Mon, 18 Jul 2016 19:23:05 +0530")
Message-ID: <87eg6qap77.fsf@purkki.adurom.net> (sfid-20160718_182526_445352_FF56DD92)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Purushottam Kushwaha <pkushwah@qti.qualcomm.com> writes:

> Driver may allow support for different beacon interval on virtual interfaces.
> Allow if such support is advertised by driver. This adds new ext_feature as
> NL80211_EXT_FEATURE_DIFF_BEACON_INTERVAL.
>
> Signed-off-by: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>

A typo in the title: "differnt"

-- 
Kalle Valo
