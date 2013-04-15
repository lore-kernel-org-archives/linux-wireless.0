Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:64654 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab3DOPQe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Apr 2013 11:16:34 -0400
Received: by mail-we0-f182.google.com with SMTP id m1so1680450wea.27
        for <linux-wireless@vger.kernel.org>; Mon, 15 Apr 2013 08:16:32 -0700 (PDT)
Date: Mon, 15 Apr 2013 17:12:29 +0200
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: vht off-by-one nss
Message-ID: <20130415151228.GC13843@magnum.frso.rivierawaves.com> (sfid-20130415_171639_015476_40946123)
References: <20130415100909.GA29924@magnum.frso.rivierawaves.com>
 <1366021975.8361.10.camel@jlt4.sipsolutions.net>
 <20130415123358.GA13843@magnum.frso.rivierawaves.com>
 <1366030075.8361.16.camel@jlt4.sipsolutions.net>
 <20130415125325.GB13843@magnum.frso.rivierawaves.com>
 <1366031187.8361.17.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1366031187.8361.17.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 15, 2013 at 03:06:27PM +0200, Johannes Berg wrote:
> On Mon, 2013-04-15 at 14:53 +0200, Karl Beldan wrote:
> 
> > > > The radiotap field is set with ieee80211_rx_status.vht_nss, so no need.
> > > 
> > > And that's properly 1-based, rather than 0-based like in TX info? I
> > > guess I forgot all of this already, heh.
> > > 
> > ieee80211_rx_status.vht_nss asks for a 1-based field but it is set by
> > drivers .. and since no driver report any (yet) .. anyways, I'll send a
> > patch along with it for mac80211_hwsim .. that can serve as a reminder ;).
> 
> I think our driver reports it already.
> 
> Anyway, looking forward to your patch :)
> 
Sent .. the description is a bit verbose for such a trivial change,
adjust as you please.
 
Karl
