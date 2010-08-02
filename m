Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:59433 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab0HBL44 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 07:56:56 -0400
Message-ID: <4C56B234.3040209@marvell.com>
Date: Mon, 02 Aug 2010 17:25:32 +0530
From: yogeshp <yogeshp@marvell.com>
MIME-Version: 1.0
To: "linville@tuxdriver.com" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: wireless-regdb: Why crda db.txt disallows 40Mhz BW on Channel 12-13
 for JP?
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello All,

Crda db.txt has following entries for JP:
        (2402 - 2472 @ 40), (N/A, 20)
        (2457 - 2482 @ 20), (N/A, 20)

Why are channel 12 and 13 for JP disallowed to operate in 40Mhz by this file? 

As per Annex 11J of latest 802.11n spec, for Japan, channel 1-7 are allowed in HT40+ and channel 5-13 are allowed in HT40- mode.

Thanks,
Yogesh

