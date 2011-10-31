Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36295 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933749Ab1JaLEg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Oct 2011 07:04:36 -0400
Received: by gyb13 with SMTP id 13so5746221gyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 31 Oct 2011 04:04:36 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 31 Oct 2011 14:04:35 +0300
Message-ID: <CAN8Fffq1M88zsMnmmcnCoRDm6WOUJ2=g5j4giRnXFHzcxSeQiQ@mail.gmail.com> (sfid-20111031_120439_901016_EE3894A3)
Subject: rt2800usb + rt3070 + AP(n mode)
From: "Andrew V. Stepanov" <stanv@altlinux.org>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello.

I have USB Wireless Adapter (ID 148f:3070 Ralink Technology, Corp.
RT2870/RT3070 Wireless Adapter).
I successfuly  set this device to AccessPoint (master) mode with
vanila kernel driver rt2800usb + hostapd. But only to G mode.
I sees speed no more 2Mbps.

Did any have success setup this device with ieee80211n=1?

Thanks.

Other WIFI USB devices based on ath9k_htc.ko successfully works in AP N mode.
