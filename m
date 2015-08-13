Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50026 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754184AbbHMUrT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 16:47:19 -0400
Message-ID: <1439498836.2114.41.camel@sipsolutions.net> (sfid-20150813_224723_153120_18B76F1C)
Subject: Re: [PATCH 0/2] iw: fixes to Android.mk to include "iw" in AOSP
 builds
From: Johannes Berg <johannes@sipsolutions.net>
To: enh <enh@google.com>
Cc: Filipe Brandenburger <filbranden@google.com>,
	Arik Nemtsov <arik@wizery.com>, linux-wireless@vger.kernel.org,
	Christopher Wiley <wiley@google.com>,
	Ying Wang <wangying@google.com>
Date: Thu, 13 Aug 2015 22:47:16 +0200
In-Reply-To: <CAJgzZoqQ=QP37k+7M_tW2HTeL_HB6YqiUsFC8eUHaGPFGPa6pA@mail.gmail.com> (sfid-20150813_224441_410819_2A37613E)
References: <1438292115-39495-1-git-send-email-filbranden@google.com>
	 <1439456484.2114.6.camel@sipsolutions.net>
	 <CADU+-uDS2C4w-dcbR8Rxx+jRfG7kNvu8JTncH-fxDnSp5NOBfQ@mail.gmail.com>
	 <1439490787.2114.36.camel@sipsolutions.net>
	 <CAJgzZoo3ifnocO84uMLa1=LKQjGWm_J3WTsw0xO2skPG9gDtng@mail.gmail.com>
	 <1439496080.2114.39.camel@sipsolutions.net>
	 <CAJgzZoqQ=QP37k+7M_tW2HTeL_HB6YqiUsFC8eUHaGPFGPa6pA@mail.gmail.com>
	 (sfid-20150813_224441_410819_2A37613E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-08-13 at 13:44 -0700, enh wrote:

> but given that our iw is your iw anyway... i don't understand the
> situation in which they'd be inconvenienced here?
> 

But it's not. We can reasonably expect everyone who actually cares to
have local modifications to iw that they aren't publishing (and that I
wouldn't apply anyway since it'd be for vendor commands) - and they
need to build *that* iw, not "our" iw.

The fact that libwifihal more or less wants you to do vendor extensions
makes that all the more likely, since if you want to test those with iw
then you need a modified iw.

johannes
