Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:46049 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756921AbcCaSwF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2016 14:52:05 -0400
Subject: Re: [PATCH 3/3] ath10k: fix unconditional num_mpdus_ready subtraction
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
	ath10k@lists.infradead.org
References: <1459352551-11773-1-git-send-email-rmanohar@qti.qualcomm.com>
 <1459352551-11773-3-git-send-email-rmanohar@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, rmanohar@codeaurora.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <56FD71D3.5090103@candelatech.com> (sfid-20160331_205208_633507_A7989E20)
Date: Thu, 31 Mar 2016 11:52:03 -0700
MIME-Version: 1.0
In-Reply-To: <1459352551-11773-3-git-send-email-rmanohar@qti.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/30/2016 08:42 AM, Rajkumar Manoharan wrote:
> Decrement num_mpdus_ready only when rx amsdu is processed successfully.
> Not doing so, will result in leak and impact stabilty under low memory
> cases.

Should this patch be rebased on top of the "ath10k: process htt rx indication as batch mode" patch?

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

