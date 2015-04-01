Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57390 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbbDAI7N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Apr 2015 04:59:13 -0400
Message-ID: <1427878747.3428.3.camel@sipsolutions.net> (sfid-20150401_105917_709309_6A036980)
Subject: Re: [PATCH v4 0/10] Improve Minstrels & Minstrel-HTs common code
 base & statistics
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>,
	linux-wireless@vger.kernel.org
Date: Wed, 01 Apr 2015 10:59:07 +0200
In-Reply-To: <5511FE44.3070802@openwrt.org>
References: <1427227783-4531-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
	 <5511FE44.3070802@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-03-25 at 01:16 +0100, Felix Fietkau wrote:
> On 2015-03-24 21:09, Thomas Huehn wrote:
> > This patch series adds several improvements to the readability, the
> > output format of rc_stats and the calculated statistics of Minstrel
> > and Minstrel-HT. Variable names got more consistent and functions
> > got unified between both rate control algorithms.
> Acked-by: Felix Fietkau <nbd@openwrt.org>

All applied, thanks.

johannes

