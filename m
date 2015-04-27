Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:32908 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932653AbbD0Nb1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Apr 2015 09:31:27 -0400
Received: by layy10 with SMTP id y10so79885636lay.0
        for <linux-wireless@vger.kernel.org>; Mon, 27 Apr 2015 06:31:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1429871610.1852.33.camel@sipsolutions.net>
References: <1427793259-18851-1-git-send-email-arik@wizery.com> <1429871610.1852.33.camel@sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Mon, 27 Apr 2015 16:31:10 +0300
Message-ID: <CA+XVXfdAgAvh49-JR24f4J_MBBy+B24xGFOVzO-=jAvo9z7eYg@mail.gmail.com> (sfid-20150427_153130_717326_6D4C6E7B)
Subject: Re: [PATCH] cfg80211: change GO_CONCURRENT to IR_CONCURRENT for STA
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 24, 2015 at 1:33 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
> On Tue, 2015-03-31 at 12:14 +0300, Arik Nemtsov wrote:
> > The GO_CONCURRENT regulatory definition can be extended to station
> > interfaces requesting to IR as part of TDLS off-channel operations.
> > Rename the GO_CONCURRENT flag to IR_CONCURRENT and allow the added
> > use-case.
> >
> > Change internal users of GO_CONCURRENT to use the new definition.
> >
> > Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
> > Reviewed-by: Johannes Berg <johannes.berg@intel.com>
> > ---
> > This patch depends on "cfg80211: Allow GO concurrent relaxation after
> > BSS disconnetion" which was recently sent by Emmanuel. It will also
> > conflict with a different change to iwlwifi/iwl-nvm-parse.c that's currently
> > in Kalle's tree ("iwlwifi: mvm: consider LAR support during NVM parse").
> > But that's not too hard to fix.
>
> Perhaps you should rebase it to not have that dependency since we're
> still discussing that other patch.

I think Ilan will send an updated version pretty soon for the
dependency. Otherwise, the conflict will happen on his side..

Arik
