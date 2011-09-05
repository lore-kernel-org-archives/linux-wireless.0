Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35308 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab1IEIWU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Sep 2011 04:22:20 -0400
Message-ID: <4E6486B5.9070105@qca.qualcomm.com> (sfid-20110905_102223_655089_7143CE66)
Date: Mon, 5 Sep 2011 11:22:13 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] ath6kl: Make ath6kl_diag_write32() non-static
References: <1314971173-8966-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1314971173-8966-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/02/2011 04:46 PM, Vasanthakumar Thiagarajan wrote:
> So that this can be called from debug.c when adding support
> to write chip register.

Thanks, all three applied. But I did a minor to change to patch 3:

Author: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Date:   Mon Sep 5 11:19:46 2011 +0300

    ath6kl: Add debugfs support to write a chip register

    To write a value to register:
    echo <register_offset>=<register_value> >
<degfs_root>/ieee80211/phyX/ath6kl/reg_write

    kvalo: rename file to reg_write to follow the style of other debugfs
files

    Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
    Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Kalle
