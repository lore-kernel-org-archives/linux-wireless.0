Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f180.google.com ([209.85.216.180]:54653 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab3KDKxd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Nov 2013 05:53:33 -0500
Received: by mail-qc0-f180.google.com with SMTP id e9so3770170qcy.25
        for <linux-wireless@vger.kernel.org>; Mon, 04 Nov 2013 02:53:32 -0800 (PST)
MIME-Version: 1.0
Reply-To: zaphod@berentweb.com
Date: Mon, 4 Nov 2013 12:53:32 +0200
Message-ID: <CAPSTskvByfGWTyDmq9WeX7Em1N0DAAZ3eKDV5eV6qfkH2gDzdA@mail.gmail.com> (sfid-20131104_115336_885246_120FC16D)
Subject: orinoco (Lucent/Agere 9.48) unable to connect
From: Beeblebrox <zaphod@berentweb.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have an old laptop that has Wifi card as stated in subject. The card
can scan and show SSID's, but cannot connect in any circumstances,
including open/unencrypted broadcast.
System: i386-pIII, running ubuntu 13.04 (driver ver: 3.8.0-32-generic
Dmesg lines for orinoco:
Fİrmware determined as Lucent/Agere  6.14
Fİrmware determined as Lucent/Agere  9.48
Wep supported, 104-bit key,  WPA-PSK supported

The log files don't give much info as to the connection error. What
method can I use to get full debug from the connection process, in
order to determine the origin of the problem (hardware, driver, etc)

Thanks and Regards.
