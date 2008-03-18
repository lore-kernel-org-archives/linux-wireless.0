Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:4098 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751898AbYCRByU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2008 21:54:20 -0400
From: bruno randolf <bruno@thinktube.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [RFC PATCH] mac80211: use hardware flags for signal/noise units
Date: Tue, 18 Mar 2008 10:54:06 +0900
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, flamingice@sourmilk.net,
	jbenc@suse.cz, jirislaby@gmail.com, mickflemm@gmail.com,
	"Johannes Berg" <johannes@sipsolutions.net>
References: <200803082101.24424.bruno@thinktube.com> <1205094875.6387.48.camel@johannes.berg> <43e72e890803171708s3361e1bbxa949cfa27086c31f@mail.gmail.com>
In-Reply-To: <43e72e890803171708s3361e1bbxa949cfa27086c31f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200803181054.06860.bruno@thinktube.com> (sfid-20080318_015424_356109_168F58DA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 18 March 2008 09:08:08 Luis R. Rodriguez wrote:
> On Sun, Mar 9, 2008 at 4:34 PM, Johannes Berg <johannes@sipsolutions.net> 
wrote:
> >  On Sat, 2008-03-08 at 21:01 +0900, bruno randolf wrote:
> >  > RFC: trying to clean up the signal/noise mess - what do you think?
> >  > (yep, my mailer probably messed up the linebreaks)
> >  >
> >  >     mac80211: use hardware flags for signal/noise units
> >
> >  No real opinion right now, on skiing vacation ;) Looks like an
> >  improvement though.
>
> I believe this counts as an ACK :) Not sure if this applies yet but it
> sure would be nice to get this in.

i'll send the patch again soon, with some minor modifications.

bruno
