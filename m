Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61819 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963Ab0HJV4t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Aug 2010 17:56:49 -0400
Received: by vws3 with SMTP id 3so8004028vws.19
        for <linux-wireless@vger.kernel.org>; Tue, 10 Aug 2010 14:56:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1281471686-16882-1-git-send-email-hauke@hauke-m.de>
References: <1281471686-16882-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 10 Aug 2010 14:56:28 -0700
Message-ID: <AANLkTi=VzJ2Y5LMsqD86WDVMqz8+45gwWPs-Wnjg2UHL@mail.gmail.com>
Subject: Re: [PATCH] compat: backport SDIO_CLASS_BT_AMP
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 10, 2010 at 1:21 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> This is needed by drivers/bluetooth/btsdio.c
>

Thanks! Applied.

  Luis
