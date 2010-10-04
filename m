Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:56504 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753512Ab0JDRWA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 13:22:00 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 04 Oct 2010 10:21:52 -0700
Date: Mon, 4 Oct 2010 10:21:59 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <ath9k-devel@lists.ath9k.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] Ath9k in funky state after adding 130 STA
 interfaces.
Message-ID: <20101004172159.GJ2105@tux>
References: <4CA81265.8030403@candelatech.com>
 <20101004170732.GH2105@tux>
 <20101004170906.22433.qmail@stuge.se>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20101004170906.22433.qmail@stuge.se>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 04, 2010 at 10:09:06AM -0700, Peter Stuge wrote:
> Luis R. Rodriguez wrote:
> > > This on wireless-testing from Friday, plus a few debugfs patches
> > > I posted recently.
> > > 
> > > I was running two STA just fine, and then tried to add 128 more.
> > 
> > You're serious right? I mean I'm happy your serious, but whoa, you
> > want 130 STAs on one interface working fine?
> 
> Come on. If it is impossible to work because of whatever limitations
> then wouldn't it make sense for the driver to throw an error instead
> of not throwing an error and just not working?

You're right but if you are using the ath9k virtual wiphy stuff please
not that code is intended to be removed, it was experimental code and
this is also why we don't have good documentation for it. It was just
a hack as a proof of concept. The real solution needs to take place on
cfg80211/mac80211.

  Luis
