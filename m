Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4181 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756285AbXI2Qiu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Sep 2007 12:38:50 -0400
Date: Sat, 29 Sep 2007 12:17:40 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, Jouni Malinen <j@w1.fi>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Kernelspace --> Userspace MLME move and related items
Message-ID: <20070929161740.GB6130@tuxdriver.com>
References: <43e72e890709281725n6a8ffe0bq487f32796a7e1cf2@mail.gmail.com> <1191066581.22960.55.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1191066581.22960.55.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 29, 2007 at 01:49:41PM +0200, Johannes Berg wrote:
> On Fri, 2007-09-28 at 20:25 -0400, Luis R. Rodriguez wrote:

> > * Should umlme be optional or is this desired mandatory down the road?
> 
> It'll be mandatory for anything that we don't currently do in the
> kernel, which will probably include
>  * 802.11r (fast roaming)
>  * 802.11s (mesh networking) (not entirely sure what management stuff
>    this includes)
>  * 802.11w (encrypted management)
>  * DLS features of 802.11e
>  * ... more I'm not thinking of right now

Can you elaborate some on why you think umlme is required for these
(or other) functions?  It isn't obvious to me that all of these MLME
functions are so complex as to require userland implementations.

Forgive my skepticisim, but in the past umlme has been used as a
religious hammer.   I don't want to keep apparently working/workable
code out of the kernel just because someone thinks currently
non-existant umlme code would be a better solution.

Lacking a mature umlme implementation in-hand, I'm not prepared
to accept a preemptive veto on kmlme extensions without seeing the
code first.

John
-- 
John W. Linville
linville@tuxdriver.com
