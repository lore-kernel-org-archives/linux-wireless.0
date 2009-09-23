Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f194.google.com ([209.85.216.194]:46906 "EHLO
	mail-px0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbZIWTZY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2009 15:25:24 -0400
Received: by pxi32 with SMTP id 32so833710pxi.4
        for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2009 12:25:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1253731843-1045-1-git-send-email-hauke@hauke-m.de>
References: <1253731843-1045-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 23 Sep 2009 12:25:08 -0700
Message-ID: <43e72e890909231225t3520e3aci2f53524187f19158@mail.gmail.com>
Subject: Re: [PATCH] [compat-2.6] fix build problems
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 23, 2009 at 11:50 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> IRQ_WAKE_THREAD is not defined in kernel < 2.6.30
> in include/linux/irqreturn.h .
>
> In 09-threaded-irq.patch the condition was wrong.

Applied, thanks.

  Luis
