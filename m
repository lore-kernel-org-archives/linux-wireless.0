Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25116 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118Ab2A3TLD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 14:11:03 -0500
Message-ID: <4F26EB38.1020001@qca.qualcomm.com> (sfid-20120130_201108_083128_12E2AF94)
Date: Mon, 30 Jan 2012 21:10:48 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: fix testmode when fw-2.bin or fw-3.bin is used
References: <20120124115016.15053.44588.stgit@localhost6.localdomain6>
In-Reply-To: <20120124115016.15053.44588.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/24/2012 01:50 PM, Kalle Valo wrote:
> Testmode (TCMD and ART) was not enabled when fw-2.bin or fw-3.bin files
> were available, fix that by fetching testmode file just after the
> board file but before rest of the firmware files are fetched.
> 
> I also added testmode field to struct ath6kl and moved the module parameter
> to core.c. Now all module parameters are grouped in one place.
> 
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Applied.

Kalle
