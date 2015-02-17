Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:51449 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932819AbbBQHLq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Feb 2015 02:11:46 -0500
Date: Tue, 17 Feb 2015 12:41:29 +0530
From: Rajkumar <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] ath10k: Bypass PLL setting on target init for
 QCA9888
Message-ID: <20150217071125.GA27497@qca.qualcomm.com> (sfid-20150217_081236_478149_00B18784)
References: <1423460814-2767-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1423460814-2767-1-git-send-email-rmanohar@qti.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 09, 2015 at 11:16:53AM +0530, Rajkumar Manoharan wrote:
> Some of of qca988x solutions are having global reset issue
> during target initialization. Bypassing PLL setting before
> downloading firmware and letting the SoC run on REF_CLK is fixing
> the problem. Corresponding firmware change is also needed to set
> the clock source once the target is initialized. Since 10.2.4
> firmware is having this ROM patch, applying skip_clock_init only
> for 10.2.4 firmware versions.
> 
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath10k/core.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
Kalle,

Its been pending for a while. Shall I resend this series?

-Rajkumar
