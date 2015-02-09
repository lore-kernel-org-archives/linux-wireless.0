Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:61605 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760141AbbBIPiT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2015 10:38:19 -0500
Received: by mail-wg0-f46.google.com with SMTP id a1so6159881wgh.5
        for <linux-wireless@vger.kernel.org>; Mon, 09 Feb 2015 07:38:17 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 9 Feb 2015 10:38:16 -0500
Message-ID: <CAJa-X977Am+yhM-yPx7SU-ELntNh998eFmeDF0O2Odw5kxK6Sg@mail.gmail.com> (sfid-20150209_163822_318401_0B496EAB)
Subject: Monitor Mode: NULL data(QOS) packets(Not Control/Mgmt/Ack/Response/key
 packets) from IPhone 6 Plus to ASUS Router(STA to AP) but not Vice Versa.
From: s prasad <sprasad.kandregula@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,
Good morning. Thank you for reading this mail. Am sorry for sending
second same mail.

Problem:
While sniffing always getting NULL function data packets(QOS) from
IPhone 6 plus to Router(STA to AP). But, AP to STA are in proper
format.

Environment:
I have one set up, which comprises of "router(ASUS 900N), IPhone 6 Plus
and Laptop".
Driver: rt2800usb
Sniffer (USB Wireless dongle): Wireless Dual Band Adaptor (Roseu ill)
450Mbps  (chip-set rt3573).
Operation System: Fedora
Driver Package: Observed on 3.14.22-1 and Latest  v3.19-rc1/.


Observations:
Able to sniff both directions data from laptop to router.
"usb_fill_bulk_urb" in function rt2x00usb_kick_tx_entry
(./rt2x00usb.c:311) giving data packets as NULL function data subtype.

Please help me.

Thanks and Regards,
S Prasad
