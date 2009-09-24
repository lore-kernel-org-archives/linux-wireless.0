Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:23270 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbZIXUvE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 16:51:04 -0400
Received: by fg-out-1718.google.com with SMTP id 22so1988600fge.1
        for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2009 13:51:07 -0700 (PDT)
Subject: Is this normal: ath9k: Two wiphys trying to scan at the same time
From: ASIC Felix <ic.felix@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Thu, 24 Sep 2009 13:51:02 -0700
Message-Id: <1253825462.19221.14.camel@darkslate>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

is this normal:

  ath9k: Two wiphys trying to scan at the same time

afaik, I did not enable virtual phy stuff. Connection appears to be
working okay. I've been seeing this for quite some time.

Setup: Laptop, Atheros MB92, kernel wireless-testing master-2009-09-23


wlan0: deauthenticated from 00:0b:85:6f:20:8c (Reason: 1)
ath9k: Two wiphys trying to scan at the same time
wlan0: direct probe to AP 00:0b:85:6f:20:8c (try 1)
wlan0 direct probe responded
wlan0: authenticate with AP 00:0b:85:6f:20:8c (try 1)
wlan0: authenticated
wlan0: associate with AP 00:0b:85:6f:20:8c (try 1)
wlan0: RX ReassocResp from 00:0b:85:6f:20:8c (capab=0x431 status=0
aid=5)
wlan0: associated

Best regards,
Felix

