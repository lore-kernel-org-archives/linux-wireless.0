Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41083 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755860Ab1AKNAi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jan 2011 08:00:38 -0500
Subject: Re: [PATCH v2 2/4] iw: Add channel busy time to survey
From: Johannes Berg <johannes@sipsolutions.net>
To: jpo234 <pommnitz@yahoo.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <loom.20110111T135315-64@post.gmane.org>
References: <20110111005107.10231.81618.stgit@localhost6.localdomain6>
	 <20110111005112.10231.46375.stgit@localhost6.localdomain6>
	 <1294734744.3611.3.camel@jlt3.sipsolutions.net>
	 <loom.20110111T135315-64@post.gmane.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Jan 2011 14:00:36 +0100
Message-ID: <1294750836.3611.25.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-01-11 at 12:57 +0000, jpo234 wrote:
> Johannes Berg <johannes@...> writes:
> > because uint64_t isn't guaranteed to be unsigned long long (in fact, it
> > is unsigned long on many machines). Please look at the commit and check.
> 
> In the commit you did a cast to unsigned long long. While this works, it's
> depends on gcc-ism, e.g. long long support. The C99 way would be to use the 
> PRIu64 macro (see stdint.h).
> see http://www.dinkumware.com/manuals/?manual=compleat&page=inttypes.html#PRIu64

Oi, that's complicated. Patch welcome I guess.

johannes

