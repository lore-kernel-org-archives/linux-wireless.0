Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38226 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755902AbXKMPeL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2007 10:34:11 -0500
Subject: Re: Wimax
From: Dan Williams <dcbw@redhat.com>
To: Patrick Ziegler <patrick.ziegler@fh-kl.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <47398FD8.6030409@fh-kl.de>
References: <47398FD8.6030409@fh-kl.de>
Content-Type: text/plain
Date: Tue, 13 Nov 2007 10:29:37 -0500
Message-Id: <1194967777.2955.31.camel@localhost.localdomain> (sfid-20071113_153424_846454_797F42CF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-11-13 at 12:51 +0100, Patrick Ziegler wrote:
> Hi,
> 
> is there any support for Wimax network cards in the kernel yet ?

No, unless those cards work like broadband cellular cards and just
present a USB serial interface to the kernel.  I haven't been able to
get a hold of WiMAX parts yet (preferably 802.16e-2005 mobile wimax
parts like the Airspan MiMAX USB) not that I've tried extremely hard.

> is this the right mailing list for this topic ?

Probably for now, yes.

> is someone working on a Wimax integration ?

I've been thinking about WiMAX for quite a while, but only recently have
real cards started to appear.  My fear is that with WiMAX, Linux will be
where it was with 802.11 3 years ago.  No hardware support, no vendor
support, nothing.

The problem with WiMAX is that many operators have _licensed_ spectrum
for WiMAX.  The software stack is more complicated, and vendors may put
more and more software on the host rather than in firmware.  However,
since software stack will deal with things like QoS in licensed spectrum
and whatnot, vendors may close the stack and do things like binary blobs
linked to the kernel module, or things like the old IPW regulatory
daemon.  Not sure how to avoid that.

Dan


