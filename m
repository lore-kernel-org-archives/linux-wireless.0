Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:39295 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964785Ab2B1Io6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Feb 2012 03:44:58 -0500
Message-ID: <4F4C9405.8050305@qca.qualcomm.com> (sfid-20120228_094501_630355_1D2C1CBA)
Date: Tue, 28 Feb 2012 10:44:53 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: <rmani@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: Lower SDIO pad drive strength for hw2.1.1 board
References: <1329892431-1499-1-git-send-email-rmani@qca.qualcomm.com>
In-Reply-To: <1329892431-1499-1-git-send-email-rmani@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/22/2012 08:33 AM, rmani@qca.qualcomm.com wrote:
> From: Raja Mani <rmani@qca.qualcomm.com>
> 
> Without this change, SDIO shuts down due to CRC error during
> data communication to the firmware in some of the platform.
> for example, scan request issued to the firmware doesn't
> return scan completed events and cause the socket interface
> to always return -16 (device busy).
> 
> SDIO pad drive strength should be reduced for hw2.1.1 board
> to avoid such errors.
> 
> Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>

Thanks, applied.

Kalle
