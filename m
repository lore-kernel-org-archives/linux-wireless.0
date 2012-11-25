Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ibawizard.net ([82.208.49.253]:48860 "EHLO
	mengele.ibawizard.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585Ab2KYX11 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Nov 2012 18:27:27 -0500
Date: Mon, 26 Nov 2012 00:27:20 +0100
From: Petr =?iso-8859-2?Q?=A9tetiar?= <ynezz@true.cz>
To: Petr =?iso-8859-2?Q?=A9tetiar?= <ynezz@true.cz>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Subject: Re: Multi-bss operation issue with rt2x00 and hostapd on rt305x
	platform
Message-ID: <20121125232720.GB16095@ibawizard.net> (sfid-20121126_002730_350392_1888B082)
Reply-To: Petr =?iso-8859-2?Q?=A9tetiar?= <ynezz@true.cz>
References: <20121125190019.GQ8292@ibawizard.net> <50B29159.20209@googlemail.com> <CAGXE3d_Wgk5Eo5Y2k-9jr3ULuOeZydmWA_pJVd8ARnKHwSGtgQ@mail.gmail.com> <20121125222940.GA16095@ibawizard.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <20121125222940.GA16095@ibawizard.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Petr ©tetiar <ynezz@true.cz> [2012-11-25 23:29:40]:

> I don't see a pattern here, why it didn't worked with :88, :89, :90? Just the
> last one :90 was working and :88, :89, :8a works fine. There need to be some
> hole/spacing? Thanks a lot!

Ok, I should go rather to bed (90 decimal vs 0x8a) :-) So, the BSSIDs should
simply use continuous numbering from the base BSSID and it works. Thank you
again.

-- ynezz
