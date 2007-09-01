Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2256 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824AbXIANpX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 09:45:23 -0400
Date: Sat, 1 Sep 2007 09:16:55 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Pavel Roskin <proski@gnu.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 18/35] Only cancel correct timeouts for Auth and Assoc  replies
Message-ID: <20070901131655.GB4462@tuxdriver.com>
References: <20070901043233.2498.95850.stgit@dv.roinet.com> <20070901043557.2498.6553.stgit@dv.roinet.com> <1188638228.7585.124.camel@johannes.berg> <1188644091.4146.12.camel@gx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1188644091.4146.12.camel@gx>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 01, 2007 at 06:54:51AM -0400, Pavel Roskin wrote:

> It would have been easier if everybody just had started with my current
> code, but since it didn't happen, I'm trying to fix it.  The first step

No doubt -- my bad.  I simply took the patch URL as posted, which
admittedly was months ago.

> is to go the the point where Kalle started mac80211 conversion.  The
> rest doesn't contain any major fixes, although some changes are pretty
> intrusive.  I'll see what to do with them once I have a chance to play
> with the mac80211 conversion patch.

I think we'll just import these into wireless-dev as-is and go from
there.  If someone spots a huge problem, then hopefully they'll post
a patch as well. :-)

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
