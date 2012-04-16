Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17037 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab2DPGMx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 02:12:53 -0400
Message-ID: <4F8BB85F.2080809@qca.qualcomm.com> (sfid-20120416_081257_313530_BF697D3C)
Date: Mon, 16 Apr 2012 09:12:47 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: <raychen@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/1] ath6kl: Fix system crash sometimes for USB hotplug
References: <1334234914-5487-1-git-send-email-raychen@qca.qualcomm.com>
In-Reply-To: <1334234914-5487-1-git-send-email-raychen@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/12/2012 03:48 PM, raychen@qca.qualcomm.com wrote:
> From: Ray Chen <raychen@qca.qualcomm.com>
> 
> System crash because of NULL pointer reference due to
> cleanup_scatter is not implemented for USB.
> 
> Signed-off-by: Ray Chen <raychen@qca.qualcomm.com>

Thanks, applied.

Kalle
