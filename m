Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:57442 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654Ab2ABRrm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jan 2012 12:47:42 -0500
Message-ID: <4F01DE07.3020502@qca.qualcomm.com> (sfid-20120102_184744_307525_6B47D61D)
Date: Mon, 2 Jan 2012 18:40:39 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vivek Natarajan <nataraja@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: Remove redundant key_index check.
References: <1325155719-4038-1-git-send-email-nataraja@qca.qualcomm.com>
In-Reply-To: <1325155719-4038-1-git-send-email-nataraja@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/29/2011 12:48 PM, Vivek Natarajan wrote:
> Less-than-zero comparison of an unsigned value is never true.
> 
> Signed-off-by: Vivek Natarajan <nataraja@qca.qualcomm.com>

Thanks, applied. I just changed the patch so that is WMI_MIN_KEY_INDEX
completely removed.

Kalle
