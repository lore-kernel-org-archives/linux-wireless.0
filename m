Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:1471 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235AbbCMQky (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2015 12:40:54 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/4] ath10k: add WMI support for WOW
References: <1425887720-11466-1-git-send-email-janusz.dziedzic@tieto.com>
Date: Fri, 13 Mar 2015 18:40:44 +0200
In-Reply-To: <1425887720-11466-1-git-send-email-janusz.dziedzic@tieto.com>
	(Janusz Dziedzic's message of "Mon, 9 Mar 2015 08:55:17 +0100")
Message-ID: <877fukrgtv.fsf@kamboji.qca.qualcomm.com> (sfid-20150313_174057_534379_A13F4861)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:

> Add WMI support for WOW like enable,
> wakeup events and host wakeup indication.
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

Patch 1 had quite a few conflicts, please check carefully my resolution
in the pending branch.

Applying: ath10k: add WMI support for WOW
Using index info to reconstruct a base tree...
Falling back to patching base and 3-way merge...
Auto-merging drivers/net/wireless/ath/ath10k/wmi.h
Auto-merging drivers/net/wireless/ath/ath10k/wmi-tlv.h
CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath10k/wmi-tlv.h
Auto-merging drivers/net/wireless/ath/ath10k/wmi-tlv.c
CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath10k/wmi-tlv.c
Auto-merging drivers/net/wireless/ath/ath10k/wmi-ops.h
CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath10k/wmi-ops.h
Failed to merge in the changes.
Patch failed at 0001 ath10k: add WMI support for WOW

-- 
Kalle Valo
