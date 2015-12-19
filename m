Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:33411 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880AbbLSLMb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Dec 2015 06:12:31 -0500
MIME-Version: 1.0
In-Reply-To: <20151219105919.GB3749@mwanda>
References: <20151219105919.GB3749@mwanda>
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Sat, 19 Dec 2015 12:12:09 +0100
Message-ID: <CAFBinCBqLVBmkx1b5xS-2YiSvD9LY_2yR3SAAR34jiTWeOV9gg@mail.gmail.com> (sfid-20151219_121238_387695_E8DA828E)
Subject: Re: [patch -next] ath9k: fix ath9k_hw_nvram_check_version()
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Dec 19, 2015 at 11:59 AM, Dan Carpenter
<dan.carpenter@oracle.com> wrote:
> There is a type bug so it always returns success.
>
> Fixes: 6fa658fd5ab2 ('ath9k: Simplify and fix eeprom endianness swapping')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>


Thank you for finding and fixing this one!
