Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6152 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760Ab2B1JX4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Feb 2012 04:23:56 -0500
Message-ID: <4F4C9D28.6050003@qca.qualcomm.com> (sfid-20120228_102403_003260_FB52AA64)
Date: Tue, 28 Feb 2012 11:23:52 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: Make sure wiphy is registered before calling
 regulatory_hint()
References: <1330161197-8593-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1330161197-8593-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/25/2012 11:13 AM, Vasanthakumar Thiagarajan wrote:
> As regulatory events are processed even before the wiphy is registered,
> calling regulatory_hint() at early stage should be fixed.
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

I take it that this depeneds on your netdev init rework patchset you
sent earlier, so I don't take this quite yet. Please correct me if I
misunderstood.

Kalle
