Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:36665 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757383Ab2CZN7g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2012 09:59:36 -0400
Message-ID: <4F707643.3090303@qca.qualcomm.com> (sfid-20120326_155940_556405_F2B4BF42)
Date: Mon, 26 Mar 2012 16:59:31 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH v2 0/9] ath6kl: add full USB support
References: <1332684929-6405-1-git-send-email-kvalo@qca.qualcomm.com>
In-Reply-To: <1332684929-6405-1-git-send-email-kvalo@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/25/2012 05:15 PM, Kalle Valo wrote:
> This adds full USB support and new HTC pipe implementation. Please review
> and send comments.
> 
> Changes in v2:
> 
> o fix sizeof(report) in htc_process_trailer() (Ray Chen)
> o add EXPORT_SYMBOL() to core.c (Ray Chen)

All nice patches applied.

Kalle
