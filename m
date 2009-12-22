Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from salugit.unile.it ([193.204.77.149]:45164 "EHLO salug.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044AbZLVLCF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Dec 2009 06:02:05 -0500
Date: Tue, 22 Dec 2009 12:02:45 +0100
From: Luca Verdesca <magooz@salug.it>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath5k: adding LED support for AR5BXB63 cards
Message-ID: <20091222120245.0df11284@magooz.no-ip.org>
In-Reply-To: <b6c5339f0912211937o525c9117k2e6d877b3c91b858@mail.gmail.com>
References: <20091222022135.2102c465@magooz.no-ip.org>
	<b6c5339f0912211937o525c9117k2e6d877b3c91b858@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Il giorno Mon, 21 Dec 2009 22:37:51 -0500
Bob Copeland <me@bobcopeland.com> ha scritto:

> On Mon, Dec 21, 2009 at 8:21 PM, Luca Verdesca <magooz@salug.it>
> wrote:
> > With following patch, LED should now work with LiteOn AR5BXB63 mini
> > pci-e cards.
[CUT]
> Would you mind re-spinning a patch using the subvendor instead of the
> Atheros device ID?  For all I know, all of the AR5BXB63s are the same,
> but just in case let's stick with subvendor until we know for sure.
> You can get the proper numbers by running lspci -vnn as root, and look
> at the other stanzas for examples.
It can seem odd, but actually I used the subvendor ID lspci shows me,
in that patch.

03:00.0 Ethernet controller [0200]: Atheros Communications Inc. AR5001 Wireless Network Adapter [168c:001c] (rev 01)
	Subsystem: Atheros Communications Inc. AR242x 802.11abg Wireless PCI Express Adapter (rev 01) [168c:3067]
[CUT]
	Kernel driver in use: ath5k
	Kernel modules: ath5k

Actually I learned it's a LiteOn by it's MAC address
(00:16:44:xx:xx:xx), because there is no writing on the card but the
model.

> Thanks!
> -Bob
Happy to contribute. :)
Luca [Magooz]
