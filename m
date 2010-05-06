Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40998 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768Ab0EFAMP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 May 2010 20:12:15 -0400
Received: by pwi5 with SMTP id 5so984990pwi.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 May 2010 17:12:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BE1BBD6.3030505@dlasys.net>
References: <4BDC001F.9050202@dlasys.net> <4BDD2E05.40203@free.fr>
	<4BDD5EB3.7020802@dlasys.net> <201005021452.01101.chunkeey@googlemail.com>
	<4BE1BBD6.3030505@dlasys.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 5 May 2010 17:11:54 -0700
Message-ID: <n2o43e72e891005051711i2e820ccdw2bd699bdfbe6a36f@mail.gmail.com>
Subject: Re: carl9170 1.0.5.1
To: dhlii@dlasys.net
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 5, 2010 at 11:41 AM, David H. Lynch Jr. <dhlii@dlasys.net> wrote:
>    I am trying to build a kernel using the carl9170 driver/firmware.
>    I am not particular about what kernel or how so long as I can get it
> running.
>
>    When I build out of the wireless-testing git tree (puled today)
> 2.6.34-rc6
>    using my current systems .config I get a very quick error on boot about
> PCI bridge windows.
>    googling the error indicates this is a know 2.6.34 problem and that there
> are fixes in other 2.6.34 trees.
>    I have been unable to find the actual patches or I would just apply them
> to wireless-testing.
>
>    Alternately, I tried to build out of the ubuntu-lucid git tree. 2.6.32
> again with my existing .config.
>    I the carl9170 driver does not build. While I found patches at OpenWRT
> that are supposed to allow building carl9170 with 2.6.33 or less,
>    the errors are unrelated to what is changed by those patches.
>
>    I have also tried using linux-source-2.6.32 pulled from cannonical via
> apt for my install rather than the ubuntu-lucid git tree
>    with similar results.

You can build the driver with compat-wireless so that way you can keep
your existing functional kernel and only backport the driver. We did
this way back when we first started doing development on ath9k and it
worked well.

  Luis
