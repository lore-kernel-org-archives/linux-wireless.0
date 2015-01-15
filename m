Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:41027 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbbAOLK1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2015 06:10:27 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/2] ath10k: add wmi-tlv debug event handling
References: <1420715897-18706-1-git-send-email-michal.kazior@tieto.com>
Date: Thu, 15 Jan 2015 13:10:14 +0200
In-Reply-To: <1420715897-18706-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 8 Jan 2015 12:18:15 +0100")
Message-ID: <87k30oxpt5.fsf@kamboji.qca.qualcomm.com> (sfid-20150115_121030_936366_10469ACC)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> New wmi-tlv firmware will deliver debug messages
> via new events.
>
> Note: This may yield some (trivial) conflicts
> against my beacon/presp template patchset.

You were right, but bonus points for having valid parent commit ids for
the 3-way merge! :)

Applying: ath10k: implement diag data container event
Using index info to reconstruct a base tree...
Falling back to patching base and 3-way merge...
Auto-merging drivers/net/wireless/ath/ath10k/wmi-tlv.h
CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath10k/wmi-tlv.h
Auto-merging drivers/net/wireless/ath/ath10k/wmi-tlv.c
CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath10k/wmi-tlv.c
Failed to merge in the changes.
Patch failed at 0001 ath10k: implement diag data container event

Please double check my conflict resolution in ath-next-test.

-- 
Kalle Valo
