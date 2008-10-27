Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:20076 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbYJ0QzD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2008 12:55:03 -0400
Date: Mon, 27 Oct 2008 09:54:18 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH] mac80211.h: fix kernel-doc excesses
Message-Id: <20081027095418.43579048.randy.dunlap@oracle.com> (sfid-20081027_175508_345440_9BBD536F)
In-Reply-To: <1225126326.3796.31.camel@johannes.berg>
References: <20081027094703.754167e2.randy.dunlap@oracle.com>
	<1225126326.3796.31.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 27 Oct 2008 17:52:06 +0100
Johannes Berg <johannes@sipsolutions.net> wrote:

> On Mon, 2008-10-27 at 09:47 -0700, Randy Dunlap wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > Fix mac80211.h kernel-doc: it had some extra parameters that were
> > no longer valid and incorrect format for a return value in 2 places.
> > 
> > Warning(lin2628-rc2//include/net/mac80211.h:1487): Excess function
> > parameter or struct member 'control' description in
> > 'ieee80211_beacon_get'
> 
> Cool, is that new functionality? Thanks.

Yes, but it reports some false positives, so I haven't
merged it yet.

> Acked-by: Johannes Berg <johannes@sipsolutions.net>


-- 
~Randy
