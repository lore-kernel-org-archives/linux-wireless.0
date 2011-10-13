Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24665 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab1JMKXF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Oct 2011 06:23:05 -0400
Message-ID: <4E96BC01.5000404@qca.qualcomm.com> (sfid-20111013_122311_624494_ED8453D6)
Date: Thu, 13 Oct 2011 13:22:57 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Sam Leffler <sleffler@chromium.org>
Subject: Re: [PATCH] ath6kl: unbreak suspend
References: <20111012074216.26442.87419.stgit@localhost6.localdomain6>
In-Reply-To: <20111012074216.26442.87419.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/12/2011 10:42 AM, Kalle Valo wrote:
> From: Sam Leffler <sleffler@chromium.org>
> 
> Add missing {}'s that caused ath6kl_sdio_suspend to always return -EINVAL
> causing suspend to be aborted.
> 
> kvalo: I broke this in commit f7325b85e ("ath6kl: add sdio debug messages")

Applied. Thanks Sam.

Kalle
