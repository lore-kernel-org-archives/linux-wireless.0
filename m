Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:6793 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424Ab2DCS1z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Apr 2012 14:27:55 -0400
Message-ID: <4F7B411D.5070903@qca.qualcomm.com> (sfid-20120403_202759_218068_C3E2F21A)
Date: Tue, 3 Apr 2012 21:27:41 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vivek Natarajan <nataraja@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>,
	PingYang Zhang <pingzhan@qca.qualcomm.com>
Subject: Re: [PATCH 1/2] ath6kl: Use vmalloc instead of kmalloc for fw
References: <1332942686-6965-1-git-send-email-nataraja@qca.qualcomm.com>
In-Reply-To: <1332942686-6965-1-git-send-email-nataraja@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/28/2012 04:51 PM, Vivek Natarajan wrote:
> Sometimes it has been observed that allocating a contiguous memory
> of more than 100K fails with kmalloc. This has been modified to
> use vmalloc instead.
> 
> Signed-off-by: PingYang Zhang <pingzhan@qca.qualcomm.com>
> Signed-off-by: Vivek Natarajan <nataraja@qca.qualcomm.com>

Thanks, both patches applied.

Kalle
