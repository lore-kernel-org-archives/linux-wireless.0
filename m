Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49542 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab3DONGb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Apr 2013 09:06:31 -0400
Message-ID: <1366031187.8361.17.camel@jlt4.sipsolutions.net> (sfid-20130415_150636_087408_DD3E4E95)
Subject: Re: vht off-by-one nss
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 15 Apr 2013 15:06:27 +0200
In-Reply-To: <20130415125325.GB13843@magnum.frso.rivierawaves.com> (sfid-20130415_145757_278426_FC740E24)
References: <20130415100909.GA29924@magnum.frso.rivierawaves.com>
	 <1366021975.8361.10.camel@jlt4.sipsolutions.net>
	 <20130415123358.GA13843@magnum.frso.rivierawaves.com>
	 <1366030075.8361.16.camel@jlt4.sipsolutions.net>
	 <20130415125325.GB13843@magnum.frso.rivierawaves.com>
	 (sfid-20130415_145757_278426_FC740E24)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-04-15 at 14:53 +0200, Karl Beldan wrote:

> > > The radiotap field is set with ieee80211_rx_status.vht_nss, so no need.
> > 
> > And that's properly 1-based, rather than 0-based like in TX info? I
> > guess I forgot all of this already, heh.
> > 
> ieee80211_rx_status.vht_nss asks for a 1-based field but it is set by
> drivers .. and since no driver report any (yet) .. anyways, I'll send a
> patch along with it for mac80211_hwsim .. that can serve as a reminder ;).

I think our driver reports it already.

Anyway, looking forward to your patch :)

johannes

