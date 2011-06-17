Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49530 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab1FQGON (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jun 2011 02:14:13 -0400
Received: by bwz15 with SMTP id 15so529063bwz.19
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jun 2011 23:14:12 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 17 Jun 2011 01:14:11 -0500
Message-ID: <BANLkTim83iarV-J08JAsVtfLR2ziqLs=iQ@mail.gmail.com> (sfid-20110617_081417_974005_132D226F)
Subject: iwlagn: Problems with Intel Wifi Link 1000 on newer kernels
From: Erik Hardesty <ehardesty@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Having trouble with iwlagn in kernels newer than 2.6.38.
I've tried 2.6.39 and 3.0rc3 and both give me the same problem.
I have the latest intel firmware installed on the system. Both
iwlwifi-1000-3.ucode
and iwlwifi-1000-5.ucode are in /lib/firmware

Note: 2.6.38 does not exhibit the same issue and works fine.

Symptom: Able to scan for access points but unable to connect.
I am unable to connect to any router regardless of it being open, WEP, or WPAx.

lspci -v | grep -i wifi:

03:00.0 Network controller: Intel Corporation WiFi Link 1000 Series
    Subsystem: Intel Corporation WiFi Link 1000 Series 1000BGN

dmesg:

myhost kernel: wlan0: direct probe to <ap> (try 1)
myhost kernel: wlan0: direct probe to <ap> (try 2)
myhost kernel: wlan0: direct probe to <ap> (try 3)
myhost kernel: wlan0: direct probe to <ap> timed out
myhost kernel: iwlagn 0000:03:00.0: fail to flush all tx fifo queues

Best,
Erik
