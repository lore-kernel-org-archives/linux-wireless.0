Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.239]:49238 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493AbYFPIpn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2008 04:45:43 -0400
Received: by rv-out-0506.google.com with SMTP id k40so3459019rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jun 2008 01:45:42 -0700 (PDT)
Message-ID: <eaf2efa20806160145s3501c07wb50f7d31efb755c0@mail.gmail.com> (sfid-20080616_104545_437627_546D7078)
Date: Mon, 16 Jun 2008 17:45:41 +0900
From: "Mark Roberts" <mroberts1839@gmail.com>
To: Chr <chunkeey@web.de>
Subject: Re: Problem with master mode on BCM4318
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200806161026.28445.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <eaf2efa20806152024i510ea7auc9aba61b68598ec0@mail.gmail.com>
	 <20080616023427.gm71g7actwc8scsg-cebfxv@webmail.spamcop.net>
	 <eaf2efa20806160010u4bc87ea9tb42c663dcf8444c1@mail.gmail.com>
	 <200806161026.28445.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> What steps should I take to apply the patches?
>
> well, I don't know much about compat-wireless, but
> for the current wireless-dev, you have to get atleast one patch form:
>
> http://johannes.sipsolutions.com/patches/kernel/all/LATEST/
>
> and there: 006-allow-ap-vlan-modes.patch

OK. I've never done this before. What should I do to apply the patch?

> For the userspace: you have to compile the _cutting-edge_ hostapd (afaik
> 0.6.4 git), you'll need it even for a unencrypted network!

Looking here:

  http://hostap.epitest.fi/hostapd/

The latest I see is 0.6.3 -- will that do?

Thanks,

M
