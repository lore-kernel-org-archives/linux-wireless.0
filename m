Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:34579 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab2E2LWl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 07:22:41 -0400
Message-ID: <4FC4B17B.1070605@qca.qualcomm.com> (sfid-20120529_132244_422794_0EBB67DB)
Date: Tue, 29 May 2012 14:22:35 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: <rmani@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath6kl: Remove unneeded memset in roam related config
 func
References: <1338186073-4986-1-git-send-email-rmani@qca.qualcomm.com>
In-Reply-To: <1338186073-4986-1-git-send-email-rmani@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/28/2012 09:21 AM, rmani@qca.qualcomm.com wrote:
> From: Raja Mani <rmani@qca.qualcomm.com>
> 
> No need to clear requested memory after allocating new SKB
> with help of ath6kl_wmi_get_new_buf(). This clear part is
> already taken care in ath6kl_wmi_get_new_buf().
> 
> Found this on code review.
> 
> Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>

Thanks, both patches applied.

Kalle
