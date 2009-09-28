Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from jupiter.gibraltar.at ([80.120.3.98]:57043 "EHLO
	mail1.gibraltar.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbZI1IH7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2009 04:07:59 -0400
From: Rene Mayrhofer <rene.mayrhofer@gibraltar.at>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Subject: Re: Massive packet loss with ath9k, AR9280, hostapd in 802.11n mode
Date: Mon, 28 Sep 2009 10:07:50 +0200
Cc: Bob Copeland <me@bobcopeland.com>, linux-wireless@vger.kernel.org
References: <200909252054.19762.rene.mayrhofer@gibraltar.at> <200909252329.01897.rene.mayrhofer@gibraltar.at> <200909280956.23887.hs4233@mail.mn-solutions.de>
In-Reply-To: <200909280956.23887.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200909281007.50856.rene.mayrhofer@gibraltar.at>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Montag, 28. September 2009 09:56:23 schrieb Holger Schurig:
> Oh, and what I'm not yet getting: how can a wrong country setting
> lead to so much packet-loss?

I don't think these two are connected - the erroneous country setting is 
probably just the reason why I can't try the 5GHz band and thus can't verify 
if the packet loss occurs there as well.
Thanks for your explanations - I will try to get CRDA and regdb running and 
will try again with the 5GHz band.


One other thing comes to mind: this 802.11n card has two antenna connectors, 
and both are actually connected to pigtails (which are probably not mounted in 
correct distance according to wavelenght, but that shouldn't cause packet 
loss). However, it might be possible that one of the antennas has a poor 
connection, is misaligned with the clients, or whatever. What I couldn't find 
in ath9k is an option for user-controlled antenna diversity (comparable to 
madwifi). How can I selectively disable antenna usage and/or set them for RX or 
TX mode only?

best regards,
Rene
