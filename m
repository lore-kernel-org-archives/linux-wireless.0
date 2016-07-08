Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:58091 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbcGHGnJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 02:43:09 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,
 1/5] ath10k: Ensure txrx-compl-task is stopped when cleaning htt-tx.
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1459545132-11295-1-git-send-email-greearb@candelatech.com>
To: Ben Greear <greearb@candelatech.com>
CC: <ath10k@lists.infradead.org>, Ben Greear <greearb@candelatech.com>,
	<linux-wireless@vger.kernel.org>
Message-ID: <6274be639a7342a7940d391ae0dac4a5@euamsexm01a.eu.qualcomm.com> (sfid-20160708_084313_212708_0318E525)
Date: Fri, 8 Jul 2016 08:43:03 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> Otherwise, the txrx-compl-task may access some bad memory?
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>

Thanks, 2 patches applied to ath-next branch of ath.git:

de0170beaa88 ath10k: ensure txrx-compl-task is stopped when cleaning htt-tx
6d68f7900d25 ath10k: ensure peer_map references are cleaned up

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/8727831/

