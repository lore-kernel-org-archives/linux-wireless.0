Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55296 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749Ab0IVQ7i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 12:59:38 -0400
Received: by gxk9 with SMTP id 9so238346gxk.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Sep 2010 09:59:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C9A34FB.5020809@gmail.com>
References: <1284918131-32065-1-git-send-email-hauke@hauke-m.de>
 <1284918131-32065-3-git-send-email-hauke@hauke-m.de> <4C9A34FB.5020809@gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 22 Sep 2010 09:59:16 -0700
Message-ID: <AANLkTinJG=mgYE-eUmptCVkXDDpSB9YDHA0AwbYi7xfw@mail.gmail.com>
Subject: Re: [PATCH 3/4] compat: move pmcia backport code into compat-2.6.36.h
To: Kshitij Kulshreshtha <kkhere.geo@gmail.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>, linux-wireless@vger.kernel.org,
	mcgrof@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 22, 2010 at 9:55 AM, Kshitij Kulshreshtha
<kkhere.geo@gmail.com> wrote:
> Hello,
>
> As on 2010-09-19 19:42, Hauke Mehrtens did write:
>> We have all out backport headers in include/linux/compat-2.6.XX.h also the pcmcia
>> part there.
>
> I'm not sure if this won't make all the compat-wireless modules depend
> on pcmcia.ko for kernels < 2.6.36 where
> pcmcia_access_configuation_register() is exported. Even if someone is
> only building selected drivers like iwlwifi or ath.

Have you tried loading ath9k or iwlagn on compat-wireless? Did you
note compat doesn't get loaded? Anyway, patches welcomed to enhance
this if your concern is if your kernel won't build with this. We also
plan on dropping PCMCIA completely anyway.

  Luis
