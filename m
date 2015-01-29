Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:56847 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbbA2KOZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2015 05:14:25 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] ath10k: move wmm param storage to vif
References: <1421657623-11706-1-git-send-email-michal.kazior@tieto.com>
Date: Thu, 29 Jan 2015 12:14:12 +0200
In-Reply-To: <1421657623-11706-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 19 Jan 2015 09:53:41 +0100")
Message-ID: <87zj913nd7.fsf@kamboji.qca.qualcomm.com> (sfid-20150129_111432_739954_AA0F892A)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> mac80211 already requests WMM per vif but firmware
> wasn't able to handle this until now. However new
> wmi-tlv firmware for qca6174 is capable of this.
>
> This prepares per-vif WMM param setup.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, all three patches applied to ath.git.

-- 
Kalle Valo
