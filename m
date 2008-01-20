Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hpsmtp-eml16.kpnxchange.com ([213.75.38.116]:37618 "EHLO
	hpsmtp-eml16.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756098AbYATXmM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jan 2008 18:42:12 -0500
From: Frans Pop <elendil@planet.nl>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [ath5k] Help needed for Trust Speedshare Turbo Pro (PCMCIA)
Date: Mon, 21 Jan 2008 00:42:10 +0100
Cc: linux-wireless@vger.kernel.org
References: <200710211316.06772.elendil@planet.nl> <43e72e890710221011p2b2f66d8w3f341bec068e49f1@mail.gmail.com> <200801210012.41021.elendil@planet.nl>
In-Reply-To: <200801210012.41021.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200801210042.10559.elendil@planet.nl> (sfid-20080120_234217_057037_9D20525E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 21 January 2008, Frans Pop wrote:
> As I don't have a wireless router at home (and no neighbors with open
> ones), I cannot try an actual connection.

Turns out I _do_ have a friendly neighbor at the back of the house :-)

I managed to associate with his AP and get an IP address using DHCP, but 
could not get any real Internet traffic (tried website and ping). Could 
possibly be a problem on his side though.

ath0: Initial auth_alg=0
ath0: authenticate with AP 00:18:39:d4:75:9e
ath0: RX authentication from 00:18:39:d4:75:9e (alg=0 transaction=2 
status=0)
ath0: authenticated
ath0: associate with AP 00:18:39:d4:75:9e
ath0: RX AssocResp from 00:18:39:d4:75:9e (capab=0x401 status=0 aid=2)
ath0: associated
ADDRCONF(NETDEV_CHANGE): ath0: link becomes ready
ath0: no IPv6 routers present
