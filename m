Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42709 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbaBZQsp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Feb 2014 11:48:45 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <greearb@candelatech.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k:  make TARGET_NUM_PEERS match WMI_MAX_KEY_INDEX.
References: <1392742567-6134-1-git-send-email-greearb@candelatech.com>
Date: Wed, 26 Feb 2014 18:48:40 +0200
In-Reply-To: <1392742567-6134-1-git-send-email-greearb@candelatech.com>
	(greearb@candelatech.com's message of "Tue, 18 Feb 2014 08:56:07
	-0800")
Message-ID: <87r46plt07.fsf@kamboji.qca.qualcomm.com> (sfid-20140226_174859_871111_E53BDFAF)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> This appears to fix the problem of running out of keys
> in the firmware.  Possibly it only hides the problem,
> however.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>

IIRC you asked me to drop this patch in other thread. I have now done
that.

-- 
Kalle Valo
