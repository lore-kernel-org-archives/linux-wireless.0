Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.184]:34498 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182AbXIWXod (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Sep 2007 19:44:33 -0400
Received: by rv-out-0910.google.com with SMTP id k20so1271399rvb
        for <linux-wireless@vger.kernel.org>; Sun, 23 Sep 2007 16:44:33 -0700 (PDT)
Message-ID: <1ba2fa240709231644l17001fb5ne531674f5b8722fd@mail.gmail.com>
Date: Mon, 24 Sep 2007 01:44:33 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/1] mac80211: add sta_notify callback
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240709220933n5783a08coeac2057b6b7da083@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1190036530108-git-send-email-tomas.winkler@intel.com>
	 <1190054680.23521.23.camel@johannes.berg>
	 <1ba2fa240709180951v3dc0a98ay11205296fd5768a@mail.gmail.com>
	 <1190197117.4414.0.camel@johannes.berg>
	 <1ba2fa240709190438o5032df52mb22a97546bdbe563@mail.gmail.com>
	 <1190204934.4414.17.camel@johannes.berg>
	 <1ba2fa240709190805i6b703e0w885390a78eda9bdc@mail.gmail.com>
	 <1190214671.4414.24.camel@johannes.berg>
	 <1ba2fa240709220933n5783a08coeac2057b6b7da083@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/22/07, Tomas Winkler <tomasw@gmail.com> wrote:
> On 9/19/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Wed, 2007-09-19 at 17:05 +0200, Tomas Winkler wrote:
> >
> > > I will do this favor for you :)  I will prepare another patch.
> >
> > Thanks :)
> >
> > You should probably base it against Michael's tree though:
> > http://git.kernel.org/?p=linux/kernel/git/mwu/mac80211-misc.git;a=summary
> > which basically consists of all the patches I had that we agreed on
> > should go in.
> >
> > Oh and please also update the comment describing the callback.
> >
> I cannot clone the tree it  gives me an error about wrong blob. I
> cannot even get snapshot from gitweb.


cg-clone http://www.kernel.org/pub/scm/linux/kernel/git/mwu/mac80211-misc.git
Initialized empty Git repository in .git/
Fetching head...
Fetching objects...
Getting alternates list for
http://www.kernel.org/pub/scm/linux/kernel/git/mwu/mac80211-misc.git
Also look at http://www.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6.24.git/
Getting pack list for
http://www.kernel.org/pub/scm/linux/kernel/git/mwu/mac80211-misc.git
Getting index for pack 91b13e9181bb0f55aac736e33abdec5c2be3303f
Getting index for pack a4dceed182e0ade8737e9c62ac789e58aa6f7655
Getting pack 91b13e9181bb0f55aac736e33abdec5c2be3303f
 which contains 4cceb887147261d7fd9fe7ce3b6d6f236c8300bc
Getting pack list for
http://www.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6.24.git/
error: Unable to find 27c3e839b54e9d81eb32a6cb7f28a1e71c05b8ef under
http://www.kernel.org/pub/scm/linux/kernel/git/mwu/mac80211-misc.git
Cannot obtain needed blob 27c3e839b54e9d81eb32a6cb7f28a1e71c05b8ef
while processing commit 38e405f56478021531ad9eda5291474fe6d120d5.
progress: 0 objects, 12873698 bytes
cg-fetch: objects fetch failed

> Thanks
> Tomas
>
