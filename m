Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42880 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab1IVHi0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 03:38:26 -0400
Message-ID: <4E7AE5E3.8010003@qca.qualcomm.com> (sfid-20110922_093830_218078_A41B9299)
Date: Thu, 22 Sep 2011 10:38:11 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vivek Natarajan <nataraja@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath6kl: Indicate the roaming capability of the firmware
References: <1316419156-3228-1-git-send-email-nataraja@qca.qualcomm.com>
In-Reply-To: <1316419156-3228-1-git-send-email-nataraja@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/19/2011 10:59 AM, Vivek Natarajan wrote:
> When the rssi of the current AP drops, both wpa_supplicant and the
> firmware may do a background scan to find a better AP and try to
> associate. This might lead to a race condition where both may try
> to connect to some AP based on their scan results.
> 
> Since the firmware is capable of handling roaming, let
> wpa_supplicant know about this capability so that it will back off
> from bgscan based roaming.

Thanks, applied.

Kalle
