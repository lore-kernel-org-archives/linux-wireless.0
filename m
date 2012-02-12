Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:50686 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756005Ab2BLX5C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Feb 2012 18:57:02 -0500
Received: by werb13 with SMTP id b13so3138198wer.19
        for <linux-wireless@vger.kernel.org>; Sun, 12 Feb 2012 15:57:01 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 12 Feb 2012 18:57:00 -0500
Message-ID: <CAGvojLdHBwbYErBwnKFnVJCeBrsvz+nKTpcRdKKkN6MyVJLGNA@mail.gmail.com> (sfid-20120213_005706_993181_688EAECE)
Subject: does ath9k_htc support promiscuous mode?
From: Tao Jin <jintao.pku@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear all,

According to this document from wireshark
http://wiki.wireshark.org/CaptureSetup/WLAN#Promiscuous_mode

some wireless cards support promiscuous mode to capture the packets
belonging to the same WLAN, but not destined to one of its local
interface.

I tried with TP-LINK TL-WN722N 802.11n USB dongle, on Ubuntu with
ath9k_htc driver.

I make the USB card associated to an AP (without encryption), and
sniff with wireshark.   Meanwhile I have another laptop sending ping
traffic through the same AP, but the USB dongle never overheard any
traffic from this laptop.  Occasionally, the USB dongle could only
overhear some downlink traffic, which is sent from AP to the laptop.

Could anyone confirm the current support of promiscuous mode on ath9k_htc?

Thanks a lot in advance!

jintao
