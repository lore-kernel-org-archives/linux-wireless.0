Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:49922 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016AbbF3Vpk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2015 17:45:40 -0400
Message-ID: <55930E01.6070909@hauke-m.de> (sfid-20150630_234652_716053_E3B159A8)
Date: Tue, 30 Jun 2015 23:45:37 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org
CC: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] bcma: populate bus DT subnodes as platform_device-s
References: <1435504633-20831-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1435504633-20831-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/28/2015 05:17 PM, Rafał Miłecki wrote:
> Our bus should allow defining children nodes as we may want to specify
> devices attached to the bus. This is required e.g. to specify NAND or
> ChipCommon cores and use bus's address and IRQ mappings.
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
>  drivers/bcma/main.c | 8 ++++++++
>  1 file changed, 8 insertions(+)

Rafał have you solved the IRQ problem? Is it possible to assign all the
sub devices the same IRQ number as the chipcommon core?

