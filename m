Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33352 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755795Ab0HPTGp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Aug 2010 15:06:45 -0400
Subject: Re: iwlwifi connection problems
From: Johannes Berg <johannes@sipsolutions.net>
To: Alex Romosan <romosan@sycorax.lbl.gov>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <877hjqpl2e.fsf@sycorax.lbl.gov>
References: <87tynqvtu6.fsf@sycorax.lbl.gov>
	 <1279917523.10769.1.camel@wwguy-huron>
	 <1280135867.3693.5.camel@jlt3.sipsolutions.net>
	 <87mxtd5xlq.fsf@sycorax.lbl.gov>
	 <1280212629.19098.0.camel@jlt3.sipsolutions.net>
	 <87bp9l6f4k.fsf@sycorax.lbl.gov>
	 <1280746705.3923.11.camel@jlt3.sipsolutions.net>
	 <878w4pvx5e.fsf@sycorax.lbl.gov>
	 <1280766201.24503.0.camel@jlt3.sipsolutions.net>
	 <87aap4z70b.fsf@sycorax.lbl.gov>
	 <1280817596.3874.0.camel@jlt3.sipsolutions.net>
	 <87mxt3n9xh.fsf@sycorax.lbl.gov>
	 <1280908365.3768.4.camel@jlt3.sipsolutions.net>
	 <87aap28m8v.fsf@sycorax.lbl.gov>
	 <1280934185.3768.8.camel@jlt3.sipsolutions.net>
	 <8739uu8lg2.fsf@sycorax.lbl.gov>
	 <1280934689.17718.3.camel@jlt3.sipsolutions.net>
	 <8762zq76p3.fsf@sycorax.lbl.gov>
	 <1281964617.3683.23.camel@jlt3.sipsolutions.net>
	 <877hjqpl2e.fsf@sycorax.lbl.gov>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Aug 2010 21:06:33 +0200
Message-ID: <1281985593.3683.27.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-08-16 at 09:40 -0700, Alex Romosan wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
> 
> > Also, have you tried the released 2.6.35.2?
> 
> just tried it with 2.6.36-rc1 (after applying a reiserfs patch) and i
> still need to comment out the call to iwlcore_commit_rxon(priv); on line
> 1361 of iwl-core.c. i'll file the bug, but if nobody steps forward,
> wouldn't it make sense just to remove that call? thanks.

You're right, I got completely confused and mixed up different bug
reports. I'd prefer to have the call there for AGN hardware, but I'll
make a patch to split it up properly. Sorry about that.

johannes

