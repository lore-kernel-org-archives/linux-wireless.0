Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54735 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755004Ab3BGJWs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2013 04:22:48 -0500
Message-ID: <1360228991.8038.3.camel@jlt4.sipsolutions.net> (sfid-20130207_102253_004126_E7D48C00)
Subject: Re: [RFC] mac80211: Add support for Tx-AMSDU viz debugfs.
From: Johannes Berg <johannes@sipsolutions.net>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: chaitanyatk@posedge.com, linux-wireless@vger.kernel.org,
	maheshp@posedge.com
Date: Thu, 07 Feb 2013 10:23:11 +0100
In-Reply-To: <CABPxzYLnWjxtN_c1sFXpA3Ye9ZNvQgV1dU0z=59j0WqgM-rUpg@mail.gmail.com> (sfid-20130207_102010_516659_782CEA2D)
References: <7384f4ddc838247a0f467708d66baa8c@posedge.com>
	 <1360225230.8038.1.camel@jlt4.sipsolutions.net>
	 <CABPxzYLnWjxtN_c1sFXpA3Ye9ZNvQgV1dU0z=59j0WqgM-rUpg@mail.gmail.com>
	 (sfid-20130207_102010_516659_782CEA2D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-02-07 at 14:49 +0530, Krishna Chaitanya wrote:
> On Thu, Feb 7, 2013 at 1:50 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Thu, 2013-02-07 at 00:01 -0800, chaitanyatk@posedge.com wrote:
> >
> 
> > Hmm. I'm not exactly happy with using (one of) the last control flag for
> > a pure debug facility.
> >
> Hmm...initially i tried to add qos header in the debugfs itself but to avoid
> code redundancy went with the TX_CTL. But in either case we need some kind
> of flag to skip adding the qos header by mac80211 (or) to set the AMSDU
> bit in the qos control header.

I guess the question is whether we really need this code in the tree at
all? It seems like a (relatively) obscure debug feature for which I'm
not sure we should touch the TX fastpath?

johannes

