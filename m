Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:41797 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab1KAGAo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Nov 2011 02:00:44 -0400
Message-ID: <4EAF8AC8.5050101@qca.qualcomm.com> (sfid-20111101_070048_494513_43F21657)
Date: Tue, 1 Nov 2011 07:59:36 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: change name of sdio driver to ath6kl
References: <20111028132326.31841.70943.stgit@localhost6.localdomain6>
In-Reply-To: <20111028132326.31841.70943.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/28/2011 04:23 PM, Kalle Valo wrote:
> Currently the name of the driver in struct sdio_driver is "ath6kl_sdio",
> this is for example what uevent advertises. This is wrong as the module
> is named as ath6kl.ko. Change it to "ath6kl" so that the names match.

Applied.

Kalle
