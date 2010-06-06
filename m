Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59404 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754393Ab0FFJVQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jun 2010 05:21:16 -0400
Received: by vws5 with SMTP id 5so1895781vws.19
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jun 2010 02:21:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1275815547-30313-4-git-send-email-hauke@hauke-m.de>
References: <1275815547-30313-1-git-send-email-hauke@hauke-m.de>
	<1275815547-30313-4-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Sun, 6 Jun 2010 02:20:53 -0700
Message-ID: <AANLkTimk6Q6Mhc5e-MmfXRcPS0O6mRo_NN4o38an5SCA@mail.gmail.com>
Subject: Re: [PATCH 4/4] compat: use kernel pm_qos_params.h
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 6, 2010 at 2:12 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> Do not use pm_qos_params.h from compat-wireless if the kernel also
> ships this file. In kernel 2.6.35 pm_qos_params.h changed and the in
> kernel header file is needed.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Dude you rock, thanks a lot for this, applied all compat-wireless and
compat patches and pushed them out. Also propagated the compat ones to
the 2.6.35.y branch FWIW.

  Luis
