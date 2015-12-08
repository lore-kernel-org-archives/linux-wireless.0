Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp02.msg.oleane.net ([62.161.4.2]:46144 "EHLO
	smtp02.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbbLHPZx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2015 10:25:53 -0500
Subject: ATH10K VLAN firmware issue
Date: Tue, 8 Dec 2015 15:29:24 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Message-ID: <773DB8A82AB6A046AE0195C68612A31901C5B293@sbs2003.acksys.local> (sfid-20151208_162600_253197_91A25921)
From: "Cedric VONCKEN" <cedric.voncken@acksys.fr>
To: <ath10k@lists.infradead.org>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

	I'm testing to transmit frame with 802.1q tag (VLAN).

	My client is set in STA + WDS and the netdev is bridged with
eth0.
	I have a computer with vlan configuration set connected to the
STA eth0.

	If I try to transmit frames with 802.1q tag, the frames are not
sent.
	I checked with wireless sniffer, and I don't see the frame with
VLAN tag (the frames without VLAN tag are sent).

	I tested with firmware 10.2.4.70.14-2 from kale github,
10.1.467-ct-com-full-015 from candelatech and 10.2.4.70-2 from openwrt,
and in all cases I have the same issue.

	Thanks for your help.

	
