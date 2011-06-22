Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41589 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755582Ab1FVNrB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 09:47:01 -0400
Subject: Re: Performance regression between Madwifi/net80211 and
 ath5k/mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Joerg Pommnitz <pommnitz@yahoo.com>
Cc: Adrian Chadd <adrian@freebsd.org>, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
In-Reply-To: <1308750102.64154.YahooMailRC@web161214.mail.bf1.yahoo.com> (sfid-20110622_154146_913504_76736765)
References: <loom.20110621T215346-191@post.gmane.org>
	 <BANLkTik0umam7S+E1oog0LTEErMz-dZamg@mail.gmail.com>
	 <1308750102.64154.YahooMailRC@web161214.mail.bf1.yahoo.com>
	 (sfid-20110622_154146_913504_76736765)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Jun 2011 15:46:56 +0200
Message-ID: <1308750416.29571.10.camel@jlt3.sipsolutions.net> (sfid-20110622_154705_996187_14EBF9A3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-06-22 at 06:41 -0700, Joerg Pommnitz wrote:
> Adrian,
> thanks for taking an interest. Today I built the current Madwifi driver for
> Fedora Kernel 2.6.38.8-32.fc15.i686. The ath5k problem seems to be at the
> tx side. If I run the iperf server on the ath5k node and the iperf client
> at the madwifi node (identical hardware config), I consistently get a 
> significant
> speedup compared to ath5k-ath5k. The only difference is, which module is
> blacklisted.
> 
> I have experimented with the RTS and fragmentation threshold setting without
> success. 
> 
> Now I'm somewhat lost. The problem is either ath5k or mac80211. 

Do you see different CPU usage? Does it max out? If so can you profile
it?

johannes

