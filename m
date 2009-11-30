Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web51404.mail.re2.yahoo.com ([206.190.38.183]:25635 "HELO
	web51404.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750884AbZK3Ikq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 03:40:46 -0500
Message-ID: <120204.2322.qm@web51404.mail.re2.yahoo.com>
Date: Mon, 30 Nov 2009 00:34:11 -0800 (PST)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: Configuring multicast/NO_ACK  data rate in mac80211
To: ath5k-devel@lists.ath5k.org, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,
we are currently evaluating whether ath5k/ath9k is able to replace Madwifi for
a project we are working on. We use Madwifi (among other things) to transmit
Video streams over multicast to a group of nodes in an IBSS network. To get 
the required data rate we rely on the Madwifi iwpriv call mcast_rate.
Is there an equivalent configuration option in mac80211?

 -- 
Regards 
Joerg 

__________________________________________________
Do You Yahoo!?
Sie sind Spam leid? Yahoo! Mail verfügt über einen herausragenden Schutz gegen Massenmails. 
http://mail.yahoo.com 
