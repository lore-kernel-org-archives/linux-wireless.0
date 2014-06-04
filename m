Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:38980 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbaFDKpo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 06:45:44 -0400
Received: by mail-wi0-f182.google.com with SMTP id r20so1162792wiv.15
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jun 2014 03:45:43 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 4 Jun 2014 16:15:41 +0530
Message-ID: <CADNhdGFNJU4EqxzDyqEnsvC+U8BV5tChyCfp2=RDF9Th8047JQ@mail.gmail.com> (sfid-20140604_124548_022311_07FC71A9)
Subject: [mac80211] WMM implementation queries
From: shankar swaminathan <shankswa@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I have 2 quick questions regarding the WMM QoS support in mac80211:

1. Is it possible to set WMM parameters like CWmin, CWmax etc on a per
Radio per SSID basis? If yes, how?

2. If the AP receives a data packet from a WMM enabled station, which
has the QoS Control field in the 802.11 header.
    The mac80211 driver converts the packet to 802.3 Ethernet type
before giving to the IP stack.
    In this case is the User Priority information present in the QoS
control field lost? Else will the Ethernet packet created in such a
case have the Priority bits set?

Thanks and regard,s
-shankar
