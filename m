Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:42930 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331Ab3KNPBG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Nov 2013 10:01:06 -0500
Received: by mail-we0-f175.google.com with SMTP id t60so2069741wes.20
        for <linux-wireless@vger.kernel.org>; Thu, 14 Nov 2013 07:01:05 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 14 Nov 2013 20:31:04 +0530
Message-ID: <CADNhdGGeOcSS+nv_LCgCN4jpAf2Lk9j5juyw4ZeWAgnqUe=+AA@mail.gmail.com> (sfid-20131114_160110_709939_A87A2FA8)
Subject: [mac80211] 802.11 data packets Rx and Tx from user space
From: shankar swaminathan <shankswa@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I had earlier posted a query specific to the rx path of mac80211.
Here is a more complete set of two queries.
Kindly help clarifying.

I am working on building a PC based Access Point in linux and have the
following queries:

1. Is there a mechanism for user space to receive 802.11 data packets
with the 802.11 header intact. I do not want to use a monitor
interface as I believe a monitor interface cannot be used to connect
wireless clients. Please clarify.

2. From user space can i transmit a fully constructed 802.11 data
frame. Will RAW sockets over WiFi work? I have not tried though.

Please help in clarifying as soon as possible.

thanks,
-shankar
