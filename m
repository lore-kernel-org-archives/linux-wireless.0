Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:42664 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758788AbcEFSJL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2016 14:09:11 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: remove VHT capabilities from 2.4GHz
Date: Fri, 6 May 2016 18:08:51 +0000
Message-ID: <87inyrnjnx.fsf@kamboji.qca.qualcomm.com> (sfid-20160506_200919_351056_D7719906)
References: <1461244669-19871-1-git-send-email-kvalo@qca.qualcomm.com>
In-Reply-To: <1461244669-19871-1-git-send-email-kvalo@qca.qualcomm.com> (Kalle
	Valo's message of "Thu, 21 Apr 2016 16:17:49 +0300")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> From: Johannes Berg <johannes.berg@intel.com>
>
> According to the spec, VHT doesn't exist in 2.4GHz.
>
> There are vendor extensions to allow a subset of VHT to work
> (notably 256-QAM), but since mac80211 doesn't support those
> advertising VHT capability on 2.4GHz leads to the behaviour
> of reporting VHT capabilities but not being able to use any
> of them due to mac80211's code requiring 80 MHz support.
>
> Remove the VHT capabilities from 2.4GHz for now. If mac80211
> gets extended to use the (likely Broadcom) vendor IEs for it
> and handles the lack of 80 MHz support, it can be added back.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Applied, thanks.

-- 
Kalle Valo