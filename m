Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:62947 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756138AbZKJQdi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 11:33:38 -0500
Received: by fxm21 with SMTP id 21so200104fxm.21
        for <linux-wireless@vger.kernel.org>; Tue, 10 Nov 2009 08:33:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4AF99161.6020308@lwfinger.net>
References: <4e9568870911100747o6088ca86lf168849e6a42b91d@mail.gmail.com>
	<4AF99161.6020308@lwfinger.net>
From: Luca Niccoli <lultimouomo@gmail.com>
Date: Tue, 10 Nov 2009 17:33:23 +0100
Message-ID: <4e9568870911100833n1bd76c05t47c095248f483ed@mail.gmail.com>
Subject: Re: Please backport [PATCH] rtl8187: Fix kernel oops when device is
	removed when LEDS enabled (Bugzilla #14539)
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/11/10 Larry Finger <Larry.Finger@lwfinger.net>:

> I'm too lazy to look for myself, and will ask here. How does Debian generate
> their source? Do they cherry pick patches from upstream? If so, then they pulled

They do, but with a very conservative approach.
I don't see anything relevant in the changelog [1]
OTOH, I use two out of kernel modules: fglrx and omnibook.
Neither of them seems to be related to this tough.
I can send my kernel config if you like.
Thanks,

Luca

[1]
http://packages.debian.org/changelogs/pool/main/l/linux-2.6/linux-2.6_2.6.31-1/changelog
