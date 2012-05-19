Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ibawizard.net ([82.208.49.253]:37602 "EHLO
	mengele.ibawizard.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175Ab2ESPo1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 May 2012 11:44:27 -0400
Date: Sat, 19 May 2012 17:34:13 +0200
From: Petr =?iso-8859-2?Q?=A9tetiar?= <ynezz@true.cz>
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com
Subject: rt2x00: is p2p possible?
Message-ID: <20120519153413.GD15710@ibawizard.net> (sfid-20120519_174431_425344_0A2F8A40)
Reply-To: Petr =?iso-8859-2?Q?=A9tetiar?= <ynezz@true.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm wondering if it would be possible to add P2P support to rt2x00 driver.
I've made some observations and it seems to me, that it should be possible,
but I'm not 100% sure, so before digging even more deeper(buying p2p specs) I
would like to ask about it first some skilled devs.

What I'm mainly unsure about is that binary blob (firmware). Do we need some
support for p2p there, or it should work with current blobs also? My rt2x00
device is following:

rt2x00_set_chip: Info - Chipset detected - rt: 2872, rf: 0005, rev: 0200

Thank you for any information/advice/pointers.

-- ynezz
