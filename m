Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out05.msg.oleane.net ([62.161.7.3]:41406 "EHLO
	smtp-out05.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969AbaIRMr3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2014 08:47:29 -0400
Received: from smtp29.msg.oleane.net (smtp29.mail.priv [172.17.20.151])
	by smtp-out05.msg.oleane.net with ESMTP id s8IAKN4K030419
	for <linux-wireless@vger.kernel.org>; Thu, 18 Sep 2014 12:20:23 +0200
Subject: RE: [PATCHv2 00/10] add support for ACK timeout estimation in ath9k driver
Date: Thu, 18 Sep 2014 11:59:48 +0200
Message-ID: <773DB8A82AB6A046AE0195C68612A319018C1FBC@sbs2003.acksys.local> (sfid-20140918_144733_639490_033CA229)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
From: "Cedric Debarge" <cedric.debarge@acksys.fr>
To: <lorenzo.bianconi83@gmail.com>
Cc: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sept 16, 2014 at 02:13:25AM +0200, Lorenzo Bianconi wrote:

Hi,

> This patchset adds support for estimation of the ACK timeout (dynack) in ath9k driver. Ath9k dynack computes the > ACK timeout based on ACK frame RX timestamp, TX frame timestamp and frame duration.
> 
> Ath9k dynack has been tested in indoor environment using AR9223/AR9280 chipset (running 3.17.0-rc5 kernel), on
> 9Km PtoP link using AR9280 chipset (running OpenWRT trunk, compat-wireless-2014-05-22) and on an AP using AR9280 > chipset (running OpenWRT trunk, compat-wireless-2014-05-22) serving 35 STA with links up to 8Km

During your indoor tests, did you managed to get precise enough timestamps to compute a significant ACK to (despite of short distances and multipaths)?

Previous tests have shown impressive bandwith gains (10% on a 9Km P2P link). Did you also get improvements in indoor environment?
 
Thanks,

Cédric DEBARGE
