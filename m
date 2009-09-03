Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f175.google.com ([209.85.223.175]:33820 "EHLO
	mail-iw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756052AbZICSPl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Sep 2009 14:15:41 -0400
Received: by iwn5 with SMTP id 5so85221iwn.4
        for <linux-wireless@vger.kernel.org>; Thu, 03 Sep 2009 11:15:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1251988316-30031-1-git-send-email-hauke@hauke-m.de>
References: <1251988316-30031-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 3 Sep 2009 11:15:24 -0700
Message-ID: <43e72e890909031115uc263d90tf279644ee2e2db90@mail.gmail.com>
Subject: Re: [compat-2.6] readd netdev_ops backport to ipw2200.c
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 3, 2009 at 7:31 AM, Hauke Mehrtens<hauke@hauke-m.de> wrote:
> This fixes building of ipw2200.c for kernel < 2.6.29.
> It was introduced in 203a12ff5a432e2ee4a83b38e698bff0dd4efead
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Applied, thanks.

  Luis
