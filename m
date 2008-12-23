Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cp-out8.libero.it ([212.52.84.108]:58185 "EHLO
	cp-out8.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbYLWAcs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2008 19:32:48 -0500
Received: from [192.168.1.102] (151.48.31.222) by cp-out8.libero.it (8.5.016.1)
        id 4946B30E0100C8EF for linux-wireless@vger.kernel.org; Tue, 23 Dec 2008 01:32:46 +0100
From: Fabio Rossi <rossi.f@inwind.it>
To: linux-wireless@vger.kernel.org
Subject: p54: ad-hoc mode doesn't work
Date: Tue, 23 Dec 2008 01:32:21 +0100
MIME-Version: 1.0
Message-Id: <200812230132.21839.rossi.f@inwind.it> (sfid-20081223_013252_632570_21B6AE47)
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I was trying to test the ad-hoc mode with my wireless nic (p54 driver, latest 
wireless-testing git) but I get the following error result:

# iwconfig wlan0 mode ad-hoc
Error for wireless request "Set Mode" (8B06) :
    SET failed on device wlan0 ; Operation not supported.

The documentation page on linuxwireless.org states that the ad-hoc mode should 
be supported: what's wrong?

Thank you,
Fabio
