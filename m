Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3479 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060AbXHMTgy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2007 15:36:54 -0400
Date: Mon, 13 Aug 2007 15:23:00 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] SSB base patch
Message-ID: <20070813192300.GD19115@tuxdriver.com>
References: <200708101316.25023.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200708101316.25023.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 10, 2007 at 01:16:23PM +0200, Michael Buesch wrote:

> Please use the following patch to base the ssb branch
> in wireless-dev on. This patch does not include all recent
> fixes and updates, but it is good as a starting point.
> I will resend all the patches, which are not includes in this
> one later, after you rebased your tree. (Which will hopefully
> happen _very_ soon)

I'm dropping this one since my rebase was occuring about the time
you sent it.  I am presuming that the later patch series you sent is
based on what I put in the wireless-dev rebase and not this.

John

P.S.  FWIW, I would still like to see a clean set of patches for
the ssb branch in a form that is suitable for pushing to Linus.
I'll bet you already guessed that. :-)
-- 
John W. Linville
linville@tuxdriver.com
