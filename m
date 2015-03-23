Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp02.msg.oleane.net ([62.161.4.2]:34174 "EHLO
	smtp02.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbbCWPQN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2015 11:16:13 -0400
Received: from acksys.fr ([195.6.104.67]) (authenticated)
	by smtp02.msg.oleane.net (MTA) with ESMTP id t2NFGATt003898
	for <linux-wireless@vger.kernel.org>; Mon, 23 Mar 2015 16:16:10 +0100
Subject: ath10k: What will happens when radar is detected ?
Date: Mon, 23 Mar 2015 16:16:09 +0100
Message-ID: <773DB8A82AB6A046AE0195C68612A319019FEF93@sbs2003.acksys.local> (sfid-20150323_161616_223498_EA9D9D1C)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
From: "Cedric VONCKEN" <cedric.voncken@acksys.fr>
To: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In 802.11ac standard, it is possible to dynamically reduce the channel
width used.
My question is:
	If I use a channel with 80 or 40 MHz width, what will happen if
I detect radar? 
		The ath10k card/driver reduces automatically the channel
width.

Cedric Voncken.
