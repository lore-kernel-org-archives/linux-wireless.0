Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:56162 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab1F2B0l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jun 2011 21:26:41 -0400
Received: by yia27 with SMTP id 27so312870yia.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jun 2011 18:26:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110628215757.GA14975@jm.kir.nu>
References: <4E0A2F8A.8010102@fedoraproject.org>
	<20110628215757.GA14975@jm.kir.nu>
Date: Wed, 29 Jun 2011 09:26:40 +0800
Message-ID: <BANLkTim=GKbSqiCsmRLXVRw2pLTUAF7wGA@mail.gmail.com> (sfid-20110629_032645_387068_D17BA7F8)
Subject: Re: [PATCH] ath9k: add module option for disabling 11n functionality
From: Adrian Chadd <adrian@freebsd.org>
To: Jouni Malinen <j@w1.fi>
Cc: Michel Alexandre Salim <salimma@fedoraproject.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29 June 2011 05:57, Jouni Malinen <j@w1.fi> wrote:

> What is so special about this that makes it impossible for open source
> drivers to handle? The proper approach here would be to figure out what
> is causing the interop issue and fix (or more likely, work around) that.

And I'd -really- appreciate it if someone did this, so we could fix
open source 11n implementations. :-)

> In addition, if this is really needed, why would this be a driver
> specific hack rather than providing a shared mechanism in mac80211 to
> disable 802.11n support? It would sound strange if there would need to
> be a new module parameter in every 802.11n driver to handle something
> like this.

+1; it should be in the 802.11 stack, not the driver itself.


Adrian
