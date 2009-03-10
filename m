Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:37462 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754532AbZCJRDX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 13:03:23 -0400
Date: Tue, 10 Mar 2009 19:03:04 +0200
From: Jouni Malinen <j@w1.fi>
To: "Stephen Gutknecht (hilltx)" <stephen@hilltx.com>
Cc: linux-wireless@vger.kernel.org,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Subject: Re: [PATCH 00/15] ath9k: Virtual interfaces and radios
Message-ID: <20090310170304.GA18634@jm.kir.nu> (sfid-20090310_180327_357164_9E7CF7A6)
References: <eef88e5b0903100543l22622769u5951003099eef312@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <eef88e5b0903100543l22622769u5951003099eef312@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 10, 2009 at 05:43:31AM -0700, Stephen Gutknecht (hilltx) wrote:

> I agree with Florian Fainelli.  As a user of ath9k I would love to see
> these patches make it into the driver.  I've not seen technical
> complaints of your patches.  Time to rebase and get them included?  Or
> at least some testing reports?

They went already in into wireless-testing git tree. I would certainly
be interested in see test reports if people are doing some experiments
with the new code. There are still number of areas that can benefit from
optimizations and combinations that do not probably work yet, so it will
be useful to know if these show up in a configuration that someone would
like to use.

-- 
Jouni Malinen                                            PGP id EFC895FA
