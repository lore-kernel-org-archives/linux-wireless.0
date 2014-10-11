Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:35867 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbaJKStF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Oct 2014 14:49:05 -0400
Received: by mail-wg0-f51.google.com with SMTP id b13so6054010wgh.22
        for <linux-wireless@vger.kernel.org>; Sat, 11 Oct 2014 11:49:02 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?Q?Nuno_Gon=C3=A7alves?= <nunojpg@gmail.com>
Date: Sat, 11 Oct 2014 19:48:42 +0100
Message-ID: <CAEXMXLQvWPSChUAN3F6F_HcxDm_d2TpG_er9pcy3GzbQcU71bA@mail.gmail.com> (sfid-20141011_204921_323620_B2C64FFC)
Subject: 802.11 Radiotap injection can't select TX rate
To: linux-wireless@vger.kernel.org
Cc: andy@warmcat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am unable to inject frames at any rate other than 1mbps.

I've tried with Andy's packetspammer [1] and with other pcap based
code (like 'aireplay-ng -9 -B wlan3'), but while the frames arrive at
the interface with the radiotap header set to other rates, they always
go into the air at 1mbps.

I have tested with Linux 3.13 and both ath9k and rt2800usb cards.

Cheers,
Nuno

[1] http://wireless.kernel.org/en/users/Documentation/packetspammer
