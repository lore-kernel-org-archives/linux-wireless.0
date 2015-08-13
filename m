Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49874 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752728AbbHMUBX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 16:01:23 -0400
Message-ID: <1439496080.2114.39.camel@sipsolutions.net> (sfid-20150813_220126_365715_302C2848)
Subject: Re: [PATCH 0/2] iw: fixes to Android.mk to include "iw" in AOSP
 builds
From: Johannes Berg <johannes@sipsolutions.net>
To: enh <enh@google.com>
Cc: Filipe Brandenburger <filbranden@google.com>,
	Arik Nemtsov <arik@wizery.com>, linux-wireless@vger.kernel.org,
	Christopher Wiley <wiley@google.com>,
	Ying Wang <wangying@google.com>
Date: Thu, 13 Aug 2015 22:01:20 +0200
In-Reply-To: <CAJgzZoo3ifnocO84uMLa1=LKQjGWm_J3WTsw0xO2skPG9gDtng@mail.gmail.com> (sfid-20150813_214845_594323_9D52C4AB)
References: <1438292115-39495-1-git-send-email-filbranden@google.com>
	 <1439456484.2114.6.camel@sipsolutions.net>
	 <CADU+-uDS2C4w-dcbR8Rxx+jRfG7kNvu8JTncH-fxDnSp5NOBfQ@mail.gmail.com>
	 <1439490787.2114.36.camel@sipsolutions.net>
	 <CAJgzZoo3ifnocO84uMLa1=LKQjGWm_J3WTsw0xO2skPG9gDtng@mail.gmail.com>
	 (sfid-20150813_214845_594323_9D52C4AB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-08-13 at 12:48 -0700, enh wrote:
> 
> i think you misunderstand what AOSP is. this code is currently in 
> AOSP master, and thus in internal master, and thus in a future 
> release.

Great, but as I understand it, vendors are under no obligation to
actually ship that code on their devices.

If a vendor needs to have an iw that, for example, supports their own
vendor commands (which, as I understand from the wifihal etc., Google
is basically forcing vendors to have!), then the AOSP iw is useless and
an own version needs to be built.


johannes
