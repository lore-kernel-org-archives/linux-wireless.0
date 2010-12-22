Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f194.google.com ([209.85.214.194]:54248 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab0LVW5e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 17:57:34 -0500
Received: by iwn42 with SMTP id 42so3146494iwn.1
        for <linux-wireless@vger.kernel.org>; Wed, 22 Dec 2010 14:57:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1293041434-3594-1-git-send-email-hauke@hauke-m.de>
References: <1293041434-3594-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 22 Dec 2010 17:57:14 -0500
Message-ID: <AANLkTinjE_CSNseR1ixLzZuZH24RsjmGYFA9X21eeMGs@mail.gmail.com>
Subject: Re: [PATCH] compat-wireless: build led support conditionally
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 22, 2010 at 1:10 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> Do not build compat-wireless with LED support when the kernel does not
> contain a led subsystem.
> This fixes some compile problems when CONFIG_LEDS_TRIGGERS is not set.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Patch applied and pushed, thanks!

  Luis
