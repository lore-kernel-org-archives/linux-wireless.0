Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-11162.dedibox.fr ([88.191.70.230]:53976 "EHLO
	sd-11162.dedibox.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106Ab0EYXJr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 May 2010 19:09:47 -0400
Date: Wed, 26 May 2010 01:00:12 +0200
From: Frederic Leroy <fredo@starox.org>
To: Paul Thomas <pthomas8589@gmail.com>
Cc: Pavel Roskin <proski@gnu.org>,
	=?UTF-8?B?R8OhYm9y?= Stefanik <netrolller.3d@gmail.com>,
	linux-wireless@vger.kernel.org,
	Andrea Merello <andreamrl@tiscali.it>,
	Jerry chuang <wlanfae@realtek.com>
Subject: Re: Realtek rtl8188 support?
Message-ID: <20100526010012.57b3d8ad@starox.org>
In-Reply-To: <AANLkTinUyRtemRZAN_IS7IqE033GPyKFe77FC94TcTYu@mail.gmail.com>
References: <c785bba31003060945j22be2e78pfeaa1bcd39fcba2c@mail.gmail.com>
	<69e28c911003061007y258ec349laa802810e0517de4@mail.gmail.com>
	<1267949782.15192.13.camel@mj>
	<69e28c911003070736t678cf6ccld0fe6dc332f4380d@mail.gmail.com>
	<1268190973.10669.12.camel@mj>
	<c785bba31003291519tfd7d26fy466a4ee4310ac590@mail.gmail.com>
	<AANLkTinUyRtemRZAN_IS7IqE033GPyKFe77FC94TcTYu@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Paul,

Le Mon, 24 May 2010 17:16:15 -0700,
Paul Thomas <pthomas8589@gmail.com> a écrit :

> On Mon, Mar 29, 2010 at 3:19 PM, Paul Thomas <pthomas8589@gmail.com>
> wrote:
> > OK, I'd love to get to where Pavel & Gabor are, but I think I'm
> > having trouble with the PCI dependency. I'm on an arm platform
> > without PCI (atmel at91sam9g20). If I remove the PCI dependency
> > from the Kconfig it does compile with warnings, and then when the
> > module loads I get "r8192s_usb: Unknown symbol wireless_send_event".
> [...]
> I haven't seen any activity on this driver in awhile. Is anyone
> working on it? My main request is to remove the PCI dependency. Any
> chance of this?

I started to work on this driver ago. But I didn't continue until
yesterday.
My adapter worked only once the first time. I have the feeling that
there need a lot of work on it until it may work.

I'm slow but still alive ;-) I will try to remove the dependency and
come back to you.

-- 
Frédéric Leroy
