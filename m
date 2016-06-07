Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47070 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880AbcFGLjM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jun 2016 07:39:12 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [v2,01/21] ath10k: Fix crash related to printing features.
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1462986153-16318-2-git-send-email-greearb@candelatech.com>
To: Ben Greear <greearb@candelatech.com>
CC: <ath10k@lists.infradead.org>, Ben Greear <greearb@candelatech.com>,
	<linux-wireless@vger.kernel.org>
Message-ID: <e2a4492749b54436ae1476c36adbcd20@euamsexm01a.eu.qualcomm.com> (sfid-20160607_133934_208463_BD40B174)
Date: Tue, 7 Jun 2016 13:38:37 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> This looks like a regression from
> c4cdf753 (move fw_features to struct ath10k_fw_file)
> 
> Signed-off-by:  Ben Greear <greearb@candelatech.com>

Thanks, 1 patch applied to ath-current branch of ath.git:

8d0a0710ea0d ath10k: fix crash related to printing features

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9073471/

