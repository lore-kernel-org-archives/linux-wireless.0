Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:32974 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964824Ab2B1Og3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Feb 2012 09:36:29 -0500
Date: Tue, 28 Feb 2012 20:06:29 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: Make sure wiphy is registered before calling
 regulatory_hint()
Message-ID: <20120228143627.GA3739@vasanth-laptop> (sfid-20120228_153633_728785_D7A48D5F)
References: <1330161197-8593-1-git-send-email-vthiagar@qca.qualcomm.com>
 <4F4C9D28.6050003@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4F4C9D28.6050003@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 28, 2012 at 11:23:52AM +0200, Kalle Valo wrote:
> On 02/25/2012 11:13 AM, Vasanthakumar Thiagarajan wrote:
> > As regulatory events are processed even before the wiphy is registered,
> > calling regulatory_hint() at early stage should be fixed.
> > 
> > Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
> 
> I take it that this depeneds on your netdev init rework patchset you
> sent earlier, so I don't take this quite yet. Please correct me if I
> misunderstood.

Yeah, this patch depends on my recent 5 patch series. I'll address the comments
in that patch series.

Vasanth
