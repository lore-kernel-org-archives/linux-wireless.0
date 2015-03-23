Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:62904 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbbCWPmI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2015 11:42:08 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v4 0/7] ath10k: add multi-channel support
References: <1426595448-1630-1-git-send-email-michal.kazior@tieto.com>
Date: Mon, 23 Mar 2015 17:41:59 +0200
In-Reply-To: <1426595448-1630-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Tue, 17 Mar 2015 12:30:41 +0000")
Message-ID: <87twxbd8l4.fsf@kamboji.qca.qualcomm.com> (sfid-20150323_164212_243516_A65DCADB)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> New qca6174 with wmi-tlv firmware supports
> multi-channel operation. To make use of it
> ath10k needs a few changes: implement mac80211's
> chanctx API and rework tx queue control a bit.

3-way merge fails:

Applying: ath10k: allow empty ssid vdev config
Applying: ath10k: implement chanctx API
error: short SHA1 7b3e6ca is ambiguous.
fatal: sha1 information is lacking or useless (drivers/net/wireless/ath/ath10k/wmi.c).
Repository lacks necessary blobs to fall back on 3-way merge.
Cannot fall back to three-way merge.
Patch failed at 0002 ath10k: implement chanctx API

And no wonder, 7 chars is just too short SHA1 abbreviation. Is there any
way to make that longer?

Anyway, can you please rebase?

-- 
Kalle Valo
