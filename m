Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60509 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbYKSQQN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2008 11:16:13 -0500
Date: Wed, 19 Nov 2008 11:01:35 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Rami Rosen <ramirose@gmail.com>, linux-wireless@vger.kernel.org,
	kune@deine-taler.de
Subject: Re: [PATCH ] zd1211rw: enable master mode. (wireless-testing)
Message-ID: <20081119160135.GB3485@tuxdriver.com> (sfid-20081119_171616_910264_E5300727)
References: <eb3ff54b0811170751p56544c8fic38d046a868f3bb8@mail.gmail.com> <1226943608.3902.36.camel@johannes.berg> <eb3ff54b0811190559g39c2176h86bd9fb1956d6730@mail.gmail.com> <1227106146.26243.43.camel@johannes.berg> <eb3ff54b0811190709q76e8b073ic71831fd38ceba18@mail.gmail.com> <1227107869.26243.52.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1227107869.26243.52.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 19, 2008 at 04:17:49PM +0100, Johannes Berg wrote:
> On Wed, 2008-11-19 at 17:09 +0200, Rami Rosen wrote:
> > Hello,
> > Thanks for your answer.
> > 
> > Now, after looking at the API doc ,  It seems to me that sequence
> > numbering is also missing in the zd1211rw driver.
> 
> Possible, but that's not a huge problem. Not having multicast buffering
> means it won't work for powersaving clients, which is.

Is there some way we could take that into account?  I'm sure there
are users who would prefer to have an AP (i.e. their laptop) that
can't support PS clients rather than not having an AP at all.

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
