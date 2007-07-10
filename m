Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from MGW3.Sony.CO.JP ([137.153.0.15]:48570 "EHLO mgw3.sony.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971AbXGJHNc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2007 03:13:32 -0400
Date: Tue, 10 Jul 2007 16:13:21 +0900
From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
To: jt@hpl.hp.com
Subject: Re: alignment issue between 32bit userland and 64bit kernel
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Jouni Malinen <jkmaline@cc.hut.fi>,
	linux-wireless@vger.kernel.org,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	geoffrey.levand@am.sony.com
In-Reply-To: <20070709164632.GA32350@bougret.hpl.hp.com>
References: <1183982603.18986.6.camel@johannes.berg> <20070709164632.GA32350@bougret.hpl.hp.com>
Message-Id: <20070710160718.D02F.MOKUNO@sm.sony.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

	Hi

On Mon, 9 Jul 2007 09:46:32 -0700
Jean Tourrilhes <jt@hpl.hp.com> wrote:

> > Jean wants to fix them in userspace. In fact, if you upgrade your
> > userspace to the really latest version it *should* work. wpa_supplicant
> > still doesn't work, nor do most distribution's versions of network
> > manager because the fixes haven't been backported.
> 
> 	You need :
> 		Wireless Tools 29-pre20 or later

I downloaded Wireless Tools 29 pre22 and its iwlist worked fine on my
PS3.

Thank you.

--
Masakazu MOKUNO

