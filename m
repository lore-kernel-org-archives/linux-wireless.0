Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2593 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965826AbXHaSop (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Aug 2007 14:44:45 -0400
Date: Fri, 31 Aug 2007 14:09:33 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: ian <ischram@telenet.be>, wireless <linux-wireless@vger.kernel.org>
Subject: Re: letting drivers choose their preferred rate scale
Message-ID: <20070831180933.GB3352@tuxdriver.com>
References: <46CF95F9.6090802@telenet.be> <1188028962.9529.13.camel@johannes.berg> <46D01D57.6060806@telenet.be> <1188211749.6756.11.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1188211749.6756.11.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 27, 2007 at 12:49:09PM +0200, Johannes Berg wrote:
> On Sat, 2007-08-25 at 14:15 +0200, ian wrote:
> 
> > I reread the discussion carefully and can't find any specific
> > comments on the patch which for clarity I will reproduce below.
> 
> Then I guess I remember wrong and the comment was raised in another
> thread. The problem we have is that once any rate control algorithm is
> loaded, it will be default for any future drivers, which is often
> inappropriate. Hence, it would be great if
> hw->preferred_rate_control==NULL would indicate "use default" where
> "default" would be set to "simple" to start with but also changeable.
> (although the change functionality could just be not usable from
> userspace for now)

I ACK this approach.  Anyone have a patch hacked-up to post?

John
-- 
John W. Linville
linville@tuxdriver.com
