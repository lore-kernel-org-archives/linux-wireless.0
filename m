Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:12293 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133AbZDQCCs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 22:02:48 -0400
Received: by wf-out-1314.google.com with SMTP id 29so682480wff.4
        for <linux-wireless@vger.kernel.org>; Thu, 16 Apr 2009 19:02:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1239909821-18401-1-git-send-email-hauke@hauke-m.de>
References: <1239909821-18401-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 16 Apr 2009 19:02:32 -0700
Message-ID: <43e72e890904161902x77b0505dh1696abbb32db7bbf@mail.gmail.com> (sfid-20090417_040252_375633_5B0EE3E9)
Subject: Re: [PATCH] [compat-2.6] Add include/linux/mmc/sdio_ids.h
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 16, 2009 at 12:23 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> The libertas driver needs some definitions out of sdio_ids.h.
> Without this it will not compile on kernel 2.6.27 to 2.6.29.

Thanks Hauke, does that file change considerably across kernels? Since
we are not backporting the SDIO stack itself we need to ensure the
current driver will access new fields not present in older kernel and
when that is done backport the changes. Curious if you had a chance to
check that.

  Luis
