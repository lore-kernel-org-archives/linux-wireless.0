Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2851 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbZLVO3F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Dec 2009 09:29:05 -0500
Date: Tue, 22 Dec 2009 09:28:41 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Luca Verdesca <magooz@salug.it>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath5k: adding LED support for AR5BXB63 cards
Message-ID: <20091222142841.GA5663@hash.localnet>
References: <20091222022135.2102c465@magooz.no-ip.org> <b6c5339f0912211937o525c9117k2e6d877b3c91b858@mail.gmail.com> <20091222120245.0df11284@magooz.no-ip.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20091222120245.0df11284@magooz.no-ip.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 22, 2009 at 12:02:45PM +0100, Luca Verdesca wrote:
> It can seem odd, but actually I used the subvendor ID lspci shows me,
> in that patch.
> 
> 03:00.0 Ethernet controller [0200]: Atheros Communications Inc. AR5001 Wireless Network Adapter [168c:001c] (rev 01)
> 	Subsystem: Atheros Communications Inc. AR242x 802.11abg Wireless PCI Express Adapter (rev 01) [168c:3067]

Huh, interesting.  Well 0x3067 isn't some other vendor device id, and I did
miss that you used PCI_SDEVICE() -- so, nevermind :)

> Happy to contribute. :)
> Luca [Magooz]

In order to be included, you should prepare a patch using diff -up, and
add your Signed-off-by (see Documentation/SubmittingPatches).  If you
do that you can also add my:

Acked-by: Bob Copeland <me@bobcopeland.com>

and copy John Linville on the patch for inclusion.

-- 
Bob Copeland %% www.bobcopeland.com

