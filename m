Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46964 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514AbbHMJB2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 05:01:28 -0400
Message-ID: <1439456484.2114.6.camel@sipsolutions.net> (sfid-20150813_110154_717700_605888F8)
Subject: Re: [PATCH 0/2] iw: fixes to Android.mk to include "iw" in AOSP
 builds
From: Johannes Berg <johannes@sipsolutions.net>
To: Filipe Brandenburger <filbranden@google.com>,
	Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Elliott Hughes <enh@google.com>,
	Christopher Wiley <wiley@google.com>
Date: Thu, 13 Aug 2015 11:01:24 +0200
In-Reply-To: <1438292115-39495-1-git-send-email-filbranden@google.com> (sfid-20150730_233636_420641_73AD4AC6)
References: <1438292115-39495-1-git-send-email-filbranden@google.com>
	 (sfid-20150730_233636_420641_73AD4AC6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-07-30 at 14:35 -0700, Filipe Brandenburger wrote:
> Hi,
> 
> I'm working on including "iw" on Android AOSP eng builds and it turns 
> out we
> need some fixes to Android.mk to make it build on a current AOSP 
> tree.
> 

We have a very similar patch internally as well (that I was still
evualating/reviewing) but it was less complete, so I've applied this
despite Arik's objections.

I think that if anyone needs to build against older Android, which is
very well possible, we can partially revert this and maybe provide some
environment variable they can control from their BSP, but until
somebody really shows up with that I'll leave it as is and assume that
older Android builds will also use older iw.

johannes
