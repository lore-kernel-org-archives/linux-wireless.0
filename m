Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42734 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab0INVaw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 17:30:52 -0400
Received: by iwn5 with SMTP id 5so6379240iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 14 Sep 2010 14:30:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100914203000.GF2484@tuxdriver.com>
References: <1283822661-16018-1-git-send-email-ohad@wizery.com> <20100914203000.GF2484@tuxdriver.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 14 Sep 2010 23:30:30 +0200
Message-ID: <AANLkTinCyHrKxDYmdbWWXNRQ+zrHtnqLLDKQa-qp3OFV@mail.gmail.com>
Subject: Re: [PATCH] wl1271: sdio: claim host only when doing IO
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@nokia.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 14, 2010 at 10:30 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> drivers/net/wireless/wl12xx/wl1271_sdio.c: In function ‘wl1271_sdio_set_power’:
> drivers/net/wireless/wl12xx/wl1271_sdio.c:193: warning: ‘return’ with a value, in function returning void
> drivers/net/wireless/wl12xx/wl1271_sdio.c:195: warning: ‘return’ with a value, in function returning void
> drivers/net/wireless/wl12xx/wl1271_sdio.c:186: warning: unused variable ‘func’

Sorry, I wrote the original patch on my branch which already
propagates the error code from set_power.

> I'll fix these in a separate patch.

If you prefer I can submit a new one.

Thanks,
Ohad.

>
> John
> --
> John W. Linville                Someday the world will need a hero, and you
> linville@tuxdriver.com                  might be all we have.  Be ready.
>
