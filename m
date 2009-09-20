Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from netsys.kaist.ac.kr ([143.248.239.50]:42060 "EHLO
	netsys.kaist.ac.kr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbZITEmh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Sep 2009 00:42:37 -0400
Received: from JinsungLeePC (netsys30.kaist.ac.kr [143.248.239.70])
	by netsys.kaist.ac.kr (8.13.1/8.13.1) with ESMTP id n8K4eThP008757
	for <linux-wireless@vger.kernel.org>; Sun, 20 Sep 2009 13:40:29 +0900
From: "Jinsung Lee" <ljs@netsys.kaist.ac.kr>
To: <linux-wireless@vger.kernel.org>
Subject: Question about carrier sensing
Date: Sun, 20 Sep 2009 13:42:47 +0900
Message-ID: <0eb001ca39ac$cd466020$67d32060$@kaist.ac.kr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, all.


I'm experimenting using MadWifi driver and Wistron CM6/CM9 cards, which all
use the Atheros chipset.
But, I found that there is some strange phenomenon on carrier sensing, which
doesn't follow the standard.
I let the two nearby transmitters just transmit the packets: one transmitter
has zero cw value and the other has positive cw values: 10, 100, 1000 where
cw is the maximum contention window size, thus the device selects the
backoff counter randomly from [0, cw].
If the carrier sensing really works, we would observe that the transmitter
with zero cw value takes all while the other don't at all, right?
Interestingly, the experimental result shows that the transmitter with
positive value has very infrequent but chances to transmit once in a while
during the whole experiment, and further the larger cw value, the much less
chance the transmitter has to transmit. So, it seems to work though.
Do you have any idea or similar experience?
Thanks.


--
Regards,
Jinsung Lee
--



