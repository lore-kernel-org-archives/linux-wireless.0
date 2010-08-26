Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37282 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982Ab0HZHXY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Aug 2010 03:23:24 -0400
Subject: Re: [RFC 0/6] "runtime" iftype switching
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20100825211036.GO2557@tuxdriver.com>
References: <20100825205619.152295081@sipsolutions.net>
	 <20100825211036.GO2557@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Aug 2010 09:23:20 +0200
Message-ID: <1282807400.3812.6.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-08-25 at 17:10 -0400, John W. Linville wrote:
> On Wed, Aug 25, 2010 at 10:56:19PM +0200, Johannes Berg wrote:
> > Here's some code to allow runtime (while the
> > interface is UP) interface type switching,
> > so far only for STA, IBSS and AP because the
> > others seem a bit trickier and harder to
> > verify.

> What is driving this?

Mostly the fact that it's awkward to set the interface down every time,
because for example every time you do that some IPv6 configuration gets
lost.

Also, "because I can" :)

johannes


