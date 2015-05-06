Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57553 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841AbbEFMt2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 May 2015 08:49:28 -0400
Message-ID: <1430916566.1954.1.camel@sipsolutions.net> (sfid-20150506_144945_382411_0A75B002)
Subject: Re: [PATCH] cfg80211: change GO_CONCURRENT to IR_CONCURRENT for STA
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 06 May 2015 14:49:26 +0200
In-Reply-To: <CA+XVXfdAgAvh49-JR24f4J_MBBy+B24xGFOVzO-=jAvo9z7eYg@mail.gmail.com> (sfid-20150427_153126_903710_F57B9234)
References: <1427793259-18851-1-git-send-email-arik@wizery.com>
	 <1429871610.1852.33.camel@sipsolutions.net>
	 <CA+XVXfdAgAvh49-JR24f4J_MBBy+B24xGFOVzO-=jAvo9z7eYg@mail.gmail.com>
	 (sfid-20150427_153126_903710_F57B9234)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-04-27 at 16:31 +0300, Arik Nemtsov wrote:
> On Fri, Apr 24, 2015 at 1:33 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> >
> > On Tue, 2015-03-31 at 12:14 +0300, Arik Nemtsov wrote:
> > > The GO_CONCURRENT regulatory definition can be extended to station
> > > interfaces requesting to IR as part of TDLS off-channel operations.
> > > Rename the GO_CONCURRENT flag to IR_CONCURRENT and allow the added
> > > use-case.
> > >
> > > Change internal users of GO_CONCURRENT to use the new definition.
> > >
> > > Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
> > > Reviewed-by: Johannes Berg <johannes.berg@intel.com>
> > > ---
> > > This patch depends on "cfg80211: Allow GO concurrent relaxation after
> > > BSS disconnetion" which was recently sent by Emmanuel. It will also
> > > conflict with a different change to iwlwifi/iwl-nvm-parse.c that's currently
> > > in Kalle's tree ("iwlwifi: mvm: consider LAR support during NVM parse").
> > > But that's not too hard to fix.
> >
> > Perhaps you should rebase it to not have that dependency since we're
> > still discussing that other patch.
> 
> I think Ilan will send an updated version pretty soon for the
> dependency. Otherwise, the conflict will happen on his side..

Ok, but it doesn't apply anyway now.

johannes

