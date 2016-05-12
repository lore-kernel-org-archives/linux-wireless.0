Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51976 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbcELGce (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2016 02:32:34 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Jaap Jan Meijer <jjmeijer88@gmail.com>,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH] brcmfmac: add fallback for devices that do not report per-chain values
References: <1462995634-24602-1-git-send-email-jjmeijer88@gmail.com>
	<57339C5B.1050307@broadcom.com>
Date: Thu, 12 May 2016 09:32:27 +0300
In-Reply-To: <57339C5B.1050307@broadcom.com> (Arend van Spriel's message of
	"Wed, 11 May 2016 22:55:55 +0200")
Message-ID: <874ma3eqh0.fsf@kamboji.qca.qualcomm.com> (sfid-20160512_083238_234759_DB93699A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> On 11-05-16 21:40, Jaap Jan Meijer wrote:
>> If brcmf_cfg80211_get_station fails to determine the RSSI from the
>> per-chain values get all values individually as a fallback.
>
> That commit message looks good.

This fixed a regression, right? So then a Fixes line would be nice:

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/SubmittingPatches#n171

-- 
Kalle Valo
