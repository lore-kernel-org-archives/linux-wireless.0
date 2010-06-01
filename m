Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from coco.cs.washington.edu ([128.208.3.82]:56288 "EHLO
	coco.cs.washington.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab0FAECB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jun 2010 00:02:01 -0400
Subject: Re: [PATCH 2.6.34] mac80211: fix blockack-req processing
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Daniel Halperin <dhalperi@cs.washington.edu>
In-Reply-To: <1275223978.3599.0.camel@jlt3.sipsolutions.net>
Date: Mon, 31 May 2010 21:01:47 -0700
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Message-Id: <BF3B435D-CEBE-428E-A0BE-3D14106FF6CB@cs.washington.edu>
References: <1275223978.3599.0.camel@jlt3.sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks!
Dan

On May 30, 2010, at 5:52 AM, Johannes Berg wrote:

> Daniel reported that the paged RX changes had
> broken blockack request frame processing due
> to using data that wasn't really part of the
> skb data.
> 
> Fix this using skb_copy_bits() for the needed
> data. As a side effect, this adds a check on
> processing too short frames, which previously
> this code could do.
> 
> Reported-by: Daniel Halperin <dhalperi@cs.washington.edu>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Acked-by: Daniel Halperin <dhalperi@cs.washington.edu>

