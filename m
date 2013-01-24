Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:32955 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab3AXP6I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2013 10:58:08 -0500
Received: by mail-lb0-f180.google.com with SMTP id q12so2363022lbc.11
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jan 2013 07:58:07 -0800 (PST)
From: Erwin Van de Velde <erwin.vandevelde@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Unable to get RTS/CTS working in rt2800
Date: Thu, 24 Jan 2013 16:58:04 +0100
Message-ID: <1731354.xZITKB59tC@sylvesterjr.pats.ua.ac.be> (sfid-20130124_165815_530329_372BB345)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear all,

In a test setup with 802.11a/n a colleague and I tried enabling RTS/CTS. The 
only thing we got however was a CTS to self. RTS threshold was 1000B, 
packet size 1400B. We looked for other options but did not find anything 
helpful, what else can we try to enable RTS/CTS?

System:
Linux OpenWrt 3.3.8
driver: rt2800pci

Best regards,
Erwin

