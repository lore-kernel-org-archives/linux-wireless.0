Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63736 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab2A1WcK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jan 2012 17:32:10 -0500
Received: by vbbfc26 with SMTP id fc26so2086629vbb.19
        for <linux-wireless@vger.kernel.org>; Sat, 28 Jan 2012 14:32:10 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 28 Jan 2012 17:32:09 -0500
Message-ID: <CACEkAT44oKcP7_Ksyoqph4yOU3Wqa15GTfp_Mw3LTD_S10weNg@mail.gmail.com> (sfid-20120128_233236_050210_41D4E123)
Subject: btcoex - ath9k hardware recommendations?
From: Andy Pyles <andy.pyles@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Any recommendations for a PCI based card that has both bluetooth and
802.11 (ath9k)?
A 3-wire device is preferred.

refererences:
http://linuxwireless.org/en/users/Documentation/Bluetooth-coexistence

http://linuxwireless.org/en/users/Drivers/ath9k/btcoex

According to these links an AR9285 device-id looks like what I need.
A quick search on this chipset turned up a card from TP-LINK which
unfortunately doesn't appear to include Bluetooth.  Are the others
cards with this chipset that are known to work well?


Thanks,
Andy
