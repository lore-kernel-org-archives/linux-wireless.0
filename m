Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27330 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755011Ab1KXMiW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Nov 2011 07:38:22 -0500
Message-ID: <4ECE3A46.8000900@qca.qualcomm.com> (sfid-20111124_133835_334050_55F724C0)
Date: Thu, 24 Nov 2011 14:36:22 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: Increase the maximum number of connections in
 AP mode
References: <1322134594-2524-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1322134594-2524-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/24/2011 01:36 PM, Vasanthakumar Thiagarajan wrote:
> The maximum number of clients which ath6kl can support in AP mode
> is 10. The limitation of 8 connections is only for older chipsets
> which ath6kl does not support.
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

Thanks, applied.

Kalle
