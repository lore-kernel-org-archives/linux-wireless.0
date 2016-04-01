Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56489 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbcDAFTH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2016 01:19:07 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Fri, 01 Apr 2016 10:49:05 +0530
From: Rajkumar Manoharan <rmanohar@codeaurora.org>
To: Ben Greear <greearb@candelatech.com>
Cc: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
	ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/3] ath10k: fix unconditional num_mpdus_ready subtraction
In-Reply-To: <56FD71D3.5090103@candelatech.com>
References: <1459352551-11773-1-git-send-email-rmanohar@qti.qualcomm.com>
 <1459352551-11773-3-git-send-email-rmanohar@qti.qualcomm.com>
 <56FD71D3.5090103@candelatech.com>
Message-ID: <73a1d6a04908fe060559d1a6e9afb128@codeaurora.org> (sfid-20160401_071912_420360_33E4E829)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-04-01 00:22, Ben Greear wrote:
> On 03/30/2016 08:42 AM, Rajkumar Manoharan wrote:
>> Decrement num_mpdus_ready only when rx amsdu is processed 
>> successfully.
>> Not doing so, will result in leak and impact stabilty under low memory
>> cases.
> 
> Should this patch be rebased on top of the "ath10k: process htt rx
> indication as batch mode" patch?
> 
It should be on top of "ath10k: speedup htt rx descriptor processing for 
rx_ind". Instead of sending next version of original series, i sent it 
as follow up.

-Rajkumar


