Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from postler.einfach.org ([86.59.21.14]:37132 "EHLO home.einfach.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752385Ab1AHDoC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 22:44:02 -0500
From: Bruno Randolf <br1@einfach.org>
To: Brian Prodoehl <bprodoehl@gmail.com>
Subject: Re: [PATCH] cfg80211: Extend channel to frequency mapping for 802.11j
Date: Sat, 8 Jan 2011 12:43:56 +0900
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
References: <20110107052600.18730.98168.stgit@localhost6.localdomain6> <AANLkTikfUb+-Phy4nwdr-Vsf2Sg8dxO7-YepbqnfwyYt@mail.gmail.com> <AANLkTimesMqYthXLSU2RBF=9=5bDXv3QtnOZapCjCquG@mail.gmail.com>
In-Reply-To: <AANLkTimesMqYthXLSU2RBF=9=5bDXv3QtnOZapCjCquG@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201101081243.56629.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 07 January 2011 21:53:25 Brian Prodoehl wrote:
> > Do all drivers still build with this patch?  I applied the previous
> > RFC version of this patch to a late-December cut of compat-wireless,
> > and had to touch the receive-handling code in a half-dozen or so
> > drivers due to the API changes.

I have to confess, I didn't check the drivers. Just tested with ath5k. Before 
this gets merged we have to fix all drivers which use these functions, true. I 
will try to do that next week...

> Ah, I see.  All the driver changes I needed were because
> ieee80211_channel_to_frequency() changed with the RFC patch, and this
> patch keeps ieee80211_channel_to_frequency() the same.  Good stuff.

Uh? This patch also changes ieee80211_channel_to_frequency(). Bad stuff. ;)

bruno
