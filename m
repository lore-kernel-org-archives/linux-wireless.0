Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4731 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbXHAAfx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 20:35:53 -0400
Date: Tue, 31 Jul 2007 20:29:27 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Daniel Drake <dsd@gentoo.org>
Cc: Jiri Benc <jbenc@suse.cz>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Subject: Re: mac80211 git tree reworked
Message-ID: <20070801002927.GC4719@tuxdriver.com>
References: <20070727175716.32242e3f@griffin.suse.cz> <46AFD024.1020708@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <46AFD024.1020708@gentoo.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 31, 2007 at 08:13:24PM -0400, Daniel Drake wrote:
> Jiri Benc wrote:
> >- up-2.6 - this is a branch with patches I'd like to push to vanilla.
> >  It contains, among other things, Johannes' restructuring patches. I'll
> >  send a pull request later today.
> 
> John, will you be pulling this into wireless-dev anytime soon? I have 
> some further mac80211 development work to do but am not sure which tree 
> I should be working on. Also my patch titled "don't allow scanning in 
> monitor mode" has got lost somewhere and I'm not sure whether it would 
> be beneficial for me to re-submit based on Jiri/Johannes' restructuring.

It isn't lost, I've got it.  I haven't been in a hurry with
2.6.24-destined patches, although I suppose I could have put it in
wireless-dev.  As you know, of course, that exact state of wireless-dev
is uncertain.

I do plan to adopt Jiri's git work.  I'm sorry I haven't got it
prepared yet.  It might be worthwhile for you to reformulate your
patch based on the restructuring.

John
-- 
John W. Linville
linville@tuxdriver.com
