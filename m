Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f202.google.com ([209.85.216.202]:35759 "EHLO
	mail-px0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab0BHSCN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2010 13:02:13 -0500
Received: by pxi40 with SMTP id 40so6698653pxi.21
        for <linux-wireless@vger.kernel.org>; Mon, 08 Feb 2010 10:02:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <25E8B46727291E4EB5A1CB88CBC4284E0100A711@zmy16exm21.fsl.freescale.net>
References: <1265467103-11474-1-git-send-email-tom.leiming@gmail.com>
	<25E8B46727291E4EB5A1CB88CBC4284E0100A711@zmy16exm21.fsl.freescale.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 8 Feb 2010 10:01:52 -0800
Message-ID: <43e72e891002081001td19c48cjf193ab8503255ee3@mail.gmail.com>
Subject: Re: [ath9k-devel] can ath9k run on linux 2.6.25
To: Zhang Yanfei-B21500 <B21500@freescale.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 8, 2010 at 1:20 AM, Zhang Yanfei-B21500
<B21500@freescale.com> wrote:
> Hi All
>        Anyone have porting the ath9k to 2.6.25? Is it can work on
> 2.6.25?
>

This tarball has 2.6.25 enabled:

http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.32/compat-wireless-2.6.32.3.tar.bz2

Newer stable kernels after this required multiqueue backported which I
gave a try but haven't gotten reports from users on:

http://bombadil.infradead.org/~mcgrof/tmp/compat-wireless-2.6.32.5-rc3.tar.bz2

After untarring you will have to select to compile only ath9k:

./scripts/driver-select ath9k

  Luis
