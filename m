Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:35059 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbbEFM76 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 May 2015 08:59:58 -0400
Received: by lbbuc2 with SMTP id uc2so6831752lbb.2
        for <linux-wireless@vger.kernel.org>; Wed, 06 May 2015 05:59:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1430916566.1954.1.camel@sipsolutions.net>
References: <1427793259-18851-1-git-send-email-arik@wizery.com>
 <1429871610.1852.33.camel@sipsolutions.net> <CA+XVXfdAgAvh49-JR24f4J_MBBy+B24xGFOVzO-=jAvo9z7eYg@mail.gmail.com>
 <1430916566.1954.1.camel@sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 6 May 2015 15:59:41 +0300
Message-ID: <CA+XVXfcAK9JAcF=3ugCEZbO4qrtsPhRaq5j4qEG7Ex1H8h9XbQ@mail.gmail.com> (sfid-20150506_150002_154285_A1D635B1)
Subject: Re: [PATCH] cfg80211: change GO_CONCURRENT to IR_CONCURRENT for STA
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 6, 2015 at 3:49 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Mon, 2015-04-27 at 16:31 +0300, Arik Nemtsov wrote:
> > On Fri, Apr 24, 2015 at 1:33 PM, Johannes Berg
> > <johannes@sipsolutions.net> wrote:
> > >
> > > On Tue, 2015-03-31 at 12:14 +0300, Arik Nemtsov wrote:
> > > > The GO_CONCURRENT regulatory definition can be extended to station
> > > > interfaces requesting to IR as part of TDLS off-channel operations.
> > > > Rename the GO_CONCURRENT flag to IR_CONCURRENT and allow the added
> > > > use-case.
> > > >
> > > > Change internal users of GO_CONCURRENT to use the new definition.
> > > >
> > > > Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
> > > > Reviewed-by: Johannes Berg <johannes.berg@intel.com>
> > > > ---
> > > > This patch depends on "cfg80211: Allow GO concurrent relaxation after
> > > > BSS disconnetion" which was recently sent by Emmanuel. It will also
> > > > conflict with a different change to iwlwifi/iwl-nvm-parse.c that's currently
> > > > in Kalle's tree ("iwlwifi: mvm: consider LAR support during NVM parse").
> > > > But that's not too hard to fix.
> > >
> > > Perhaps you should rebase it to not have that dependency since we're
> > > still discussing that other patch.
> >
> > I think Ilan will send an updated version pretty soon for the
> > dependency. Otherwise, the conflict will happen on his side..
>
> Ok, but it doesn't apply anyway now.

I'll fix it then :)

Arik
