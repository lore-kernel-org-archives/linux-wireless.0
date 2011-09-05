Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:9553 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab1IEIys (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Sep 2011 04:54:48 -0400
Date: Mon, 5 Sep 2011 14:24:25 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] ath6kl: Make ath6kl_diag_write32() non-static
Message-ID: <20110905085424.GA11758@vasanth-laptop> (sfid-20110905_105451_844666_9B10C9D6)
References: <1314971173-8966-1-git-send-email-vthiagar@qca.qualcomm.com> <4E6486B5.9070105@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4E6486B5.9070105@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 05, 2011 at 11:22:13AM +0300, Kalle Valo wrote:
> On 09/02/2011 04:46 PM, Vasanthakumar Thiagarajan wrote:
> > So that this can be called from debug.c when adding support
> > to write chip register.
> 
> Thanks, all three applied. But I did a minor to change to patch 3:
> 
> Author: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
> Date:   Mon Sep 5 11:19:46 2011 +0300
> 
>     ath6kl: Add debugfs support to write a chip register
> 
>     To write a value to register:
>     echo <register_offset>=<register_value> >
> <degfs_root>/ieee80211/phyX/ath6kl/reg_write
> 
>     kvalo: rename file to reg_write to follow the style of other debugfs
> files

Thanks.

Vasanth
