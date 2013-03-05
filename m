Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:52200 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755866Ab3CEW0x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Mar 2013 17:26:53 -0500
Received: by mail-wg0-f47.google.com with SMTP id dr13so6692826wgb.14
        for <linux-wireless@vger.kernel.org>; Tue, 05 Mar 2013 14:26:51 -0800 (PST)
Date: Tue, 5 Mar 2013 23:27:48 +0100
From: john <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Karl Beldan <karl.beldan@gmail.com>,
	Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: Re: [PATCH v2 1/2] mac80211: get the rates masks from the txrc in
 rate_control_get_rate
Message-ID: <20130305222748.GA31280@gobelin> (sfid-20130305_232659_055706_119C9AEB)
References: <1362421635-28008-1-git-send-email-karl.beldan@gmail.com>
 <1362427924.21028.42.camel@jlt4.sipsolutions.net>
 <20130304204541.GA8819@gobelin>
 <5135F327.4000408@openwrt.org>
 <20130305161003.GA30419@magnum.frso.rivierawaves.com>
 <1362509619.8224.5.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1362509619.8224.5.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 05, 2013 at 07:53:39PM +0100, Johannes Berg wrote:
> On Tue, 2013-03-05 at 17:10 +0100, Karl Beldan wrote:
> 
> > > It seems to me that all of this could be made more efficient by default
> > > if a mcs mask pointer is only passed to rate control if the user
> > > actually configured a MCS mask. Also, filtering out rates from the mask
> > > that the sta does not support seems a bit unnecessary, since the rate
> > > control usually looks at the HT capabilities and the sta's mcs rx mask
> > > anyway.
> > > 
> > Yes, some things look a bit overkill in the masks logic.
> 
> Are you planning to send new patches to improve this?
> 
I'll see what I can come up with.
 
Karl
