Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33750 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab2FOIUU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jun 2012 04:20:20 -0400
Message-ID: <1339748416.4512.9.camel@jlt3.sipsolutions.net> (sfid-20120615_102026_647029_2275B4BE)
Subject: Re: [PATCH] mac80211: fix the assignment of mesh element TTL
From: Johannes Berg <johannes@sipsolutions.net>
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	devel@lists.open80211s.org
Date: Fri, 15 Jun 2012 10:20:16 +0200
In-Reply-To: <CAEFj985xi0LNsLqHn1cgAw0oMVsfWrh_ioPuzUva8ZLbUTn=ZQ@mail.gmail.com> (sfid-20120615_023221_846663_D2EB7189)
References: <1339691033-13316-1-git-send-email-yeohchunyeow@gmail.com>
	 <1339700228.9786.11.camel@jlt3.sipsolutions.net>
	 <CAEFj985xi0LNsLqHn1cgAw0oMVsfWrh_ioPuzUva8ZLbUTn=ZQ@mail.gmail.com>
	 (sfid-20120615_023221_846663_D2EB7189)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-06-15 at 08:32 +0800, Yeoh Chun-Yeow wrote:
> Yes.
> 
> On Fri, Jun 15, 2012 at 2:57 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Fri, 2012-06-15 at 00:23 +0800, Chun-Yeow Yeoh wrote:
> >> This patch fixes the wrong assignment of mesh element TTL.
> >
> > Since I haven't pushed to John yet, should I rebase and merge this with
> > one of the previous patches?

Umm, I actually shouldn't ... The patch this fixes has been merged by
John way back:

commit 45904f21655cf4f0ae7d0fab5906fe51bf56ecf4
Author:     Javier Cardona <javier@cozybit.com>
AuthorDate: Fri Dec 3 09:20:40 2010 +0100
Commit:     John W. Linville <linville@tuxdriver.com>
CommitDate: Mon Dec 6 16:01:28 2010 -0500

    nl80211/mac80211: define and allow configuring mesh element TTL


WAY WAY back. Maybe this patch should go into 3.5 and even stable?

johannes

