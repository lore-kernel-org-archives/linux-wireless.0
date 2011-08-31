Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:26542 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580Ab1HaIHs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 04:07:48 -0400
Date: Wed, 31 Aug 2011 13:37:27 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <kvalo@adurom.com>
Subject: Re: [PATCH] ath6kl: Add debugfs interface to dump diagnostic
	registers
Message-ID: <20110831080726.GB1234@vasanth-laptop> (sfid-20110831_100753_753016_359680FB)
References: <1314717419-16512-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1314717419-16512-1-git-send-email-vthiagar@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 30, 2011 at 08:46:59PM +0530, Vasanthakumar Thiagarajan wrote:
> To dump a particular register, echo reg_addr > <debugfs_root>/ieee80211/phyX/ath6kl/reg_addr,
> to dump the entire register set, echo 0 > <debugfs_root>/ieee80211/phyX/ath6kl/reg_addr, and
> register values will be available at <debugfs_root>/ieee80211/phyX/ath6kl/reg_dump.
> 

I'm fixing endian issues with chip register read/write. Please drop
this patch. I'll rebase it with my endian patches.

Vasanth 
