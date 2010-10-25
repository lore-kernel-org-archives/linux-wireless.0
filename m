Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56161 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755923Ab0JYQhZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Oct 2010 12:37:25 -0400
Received: by iwn10 with SMTP id 10so1023964iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 25 Oct 2010 09:37:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1288021004-7315-1-git-send-email-mshajakhan@atheros.com>
References: <1288021004-7315-1-git-send-email-mshajakhan@atheros.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 25 Oct 2010 09:36:15 -0700
Message-ID: <AANLkTi=M9AR6ubFfuZb3rDLit_DvrkL14emM7OQYdmSb@mail.gmail.com>
Subject: Re: [RFC] ath9k: Fix incorrect access of rate flags in RC
To: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org, j@w1.fi,
	Senthilkumar.Balasubramanian@atheros.com,
	Vasanth.Thiagarajan@atheros.com, nbd@openwrt.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 25, 2010 at 8:36 AM, Mohammed Shafi Shajakhan
<mshajakhan@atheros.com> wrote:
> From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
>
> The index variable to access the rate flags should be obtained from the
> inner loop counter which corresponds to rate table structure.
>
> Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

Is this a stable fix?

  Luis
