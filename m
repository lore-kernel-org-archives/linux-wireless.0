Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:14501 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789Ab2GSNIq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jul 2012 09:08:46 -0400
Message-ID: <500806D9.1010200@qca.qualcomm.com> (sfid-20120719_150854_901079_93CBBAD5)
Date: Thu, 19 Jul 2012 16:08:41 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] ath6kl: refactor wmi scan command
References: <20120719125937.22047.91375.stgit@x201> <20120719130048.22047.69322.stgit@x201>
In-Reply-To: <20120719130048.22047.69322.stgit@x201>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/19/2012 04:00 PM, Kalle Valo wrote:
> ATH6KL_FW_CAPABILITY_STA_P2PDEV_DUPLEX was checked in cfg80211.c which is
> a bit awkward when adding more callsites to the scan functions. Refactor
> the code to wmi.c so that it's transparent to the callers.
> 
> Even though the patch looks scary there are no functional changes. I
> just had to move ath6kl_wmi_startscan_cmd() before
> ath6kl_wmi_beginscan_cmd() which confuses patch.
> 
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

I removed the second paragraph during commit as it wasn't true anymore
after splitting the patch.

Kalle
