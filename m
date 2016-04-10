Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:32897 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbcDJKow (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Apr 2016 06:44:52 -0400
MIME-Version: 1.0
In-Reply-To: <1460229061-28407-1-git-send-email-mohammed.billoo@gmail.com>
References: <1460229061-28407-1-git-send-email-mohammed.billoo@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Sun, 10 Apr 2016 20:44:31 +1000
Message-ID: <CAGRGNgXL5PUAxBYo3+r2VCy7ZEkwC=3NOtbNaKG1L17XqkXYdA@mail.gmail.com> (sfid-20160410_124509_157524_38A0A953)
Subject: Re: [PATCH] staging: wilc1000: rework comments in wilc_sdio.c
To: mohammed.billoo@gmail.com
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Mohammed,

On Sun, Apr 10, 2016 at 5:11 AM,  <mohammed.billoo@gmail.com> wrote:
> From: Mohammed Billoo <mohammed.billoo@gmail.com>
>
> Remove unnecessary comments (highlighting sections of functions), make
> multiline comments into single line comments, and ensure that multiline
> comments adhere to coding style.

You need to add a signed-off-by line here.

> ---
>  drivers/staging/wilc1000/wilc_sdio.c | 136 ++++++++---------------------------
>  1 file changed, 31 insertions(+), 105 deletions(-)
>

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
