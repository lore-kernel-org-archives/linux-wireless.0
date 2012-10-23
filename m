Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41884 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756666Ab2JWHU4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Oct 2012 03:20:56 -0400
Message-ID: <1350976883.10322.0.camel@jlt4.sipsolutions.net> (sfid-20121023_092100_987010_9470A1F9)
Subject: Re: Cannot bring up second VAP on recent kernels?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 23 Oct 2012 09:21:23 +0200
In-Reply-To: <5085D66C.3060307@candelatech.com> (sfid-20121023_012747_100309_DEBCD1EF)
References: <5085AA78.1080809@candelatech.com>
	 <5085B866.8060306@openwrt.org> <5085BA0E.6080903@candelatech.com>
	 <5085BE64.6030802@openwrt.org> <5085CE19.2000505@candelatech.com>
	 <5085D66C.3060307@candelatech.com> (sfid-20121023_012747_100309_DEBCD1EF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-10-22 at 16:27 -0700, Ben Greear wrote:

> Well, crap, it looks like it is this commit.  No one considered wanting
> to run two hostapd processes on one wiphy :(

I'm not sure why you'd want to? It'll work just as well with a single
process, and *you* were the one who was so concerned about userspace
overhead first ;-)

You could fall back to monitor mode AP implementation?

johannes

