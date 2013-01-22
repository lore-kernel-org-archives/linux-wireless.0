Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.medihelpline.net ([211.55.81.226]:54703 "EHLO
	mail.ebizcenter.co.kr" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752263Ab3AVIjk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jan 2013 03:39:40 -0500
Received: from GYJ ([39.115.113.222]:3749)
	by ktpbx.com with [XMail 1.22 PassKorea080324 ESMTP Server]
	id <S614C02> for <linux-wireless@vger.kernel.org> from <gyj@x-node.co.kr>;
	Tue, 22 Jan 2013 17:07:28 +0900
From: =?utf-8?B?6raM7Jqp7KeE?= <gyj@x-node.co.kr>
To: <linux-wireless@vger.kernel.org>
Cc: <ath6kl-devel@qualcomm.com>
Subject: AR6003 :: IP packet is not received.
Date: Tue, 22 Jan 2013 17:32:47 +0900
Message-ID: <000301cdf87b$0ef2a020$2cd7e060$@co.kr> (sfid-20130122_093943_138783_B4A78D6F)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear ath6kl-devel,

I Korea's human-intech Work in a company that is Gueon.
I am porting and embeded-board wlan AR6003 chipset features.
embeded-board CPU samsung S5PV210, linux kenel-2.6.32 is used.

wpa_supplicant using softAP mode, powered by letting success to other client devices (ex: Desktop PC) AP Access.
	[wpa_supplicant -i wlan0 -c /home/ath6k/SoftAP/softap.conf -Dnl80211 -B]
	[version : wpa_supplicant v2.0-devel Copyright (c) 2003-2012]

Does not accept the IP address from the DHCP client device(PC), the problem occurs.

I have a problem during the analysis.
I spoke to experiment by setting a fixed IP without using a DHCP
When embeded-Board from the PC to ping-test responses.
However, PC from the embedded-Board to ping-test does not responses.

Whether the idea of ​​something I could try?

Thanks and Best Regards,
Gueon.



