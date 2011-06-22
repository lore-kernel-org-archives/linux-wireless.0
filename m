Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm6.bullet.mail.bf1.yahoo.com ([98.139.212.165]:42201 "HELO
	nm6.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757764Ab1FVPCj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 11:02:39 -0400
References: <loom.20110621T215346-191@post.gmane.org>  <BANLkTik0umam7S+E1oog0LTEErMz-dZamg@mail.gmail.com>  <1308750102.64154.YahooMailRC@web161214.mail.bf1.yahoo.com>  (sfid-20110622_154146_913504_76736765) <1308750416.29571.10.camel@jlt3.sipsolutions.net>  <1308753669.17439.YahooMailRC@web161208.mail.bf1.yahoo.com> <1308754204.29571.15.camel@jlt3.sipsolutions.net>
Message-ID: <1308754958.21498.YahooMailRC@web161204.mail.bf1.yahoo.com> (sfid-20110622_170242_719585_29263C1F)
Date: Wed, 22 Jun 2011 08:02:38 -0700 (PDT)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: AW: Performance regression between Madwifi/net80211 and ath5k/mac80211
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Adrian Chadd <adrian@freebsd.org>, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
In-Reply-To: <1308754204.29571.15.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I guess you'll  need more help from the HW people here.

Unless the delay is somewhere in the generic mac80211 stack.

The older Atheros hardware is unique, because it has not just
two hardware drivers but also two 802.11 stacks.

It would be nice if somebody could do a similar test with two
different 802.11 stacks and drivers. Comparing the performance
between libertas and libertas_tf might provide an interesting
data point.

 -- 
Regards 
Joerg 
