Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:34852 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab3DJIF5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 04:05:57 -0400
Received: by mail-pb0-f45.google.com with SMTP id ro12so129859pbb.32
        for <linux-wireless@vger.kernel.org>; Wed, 10 Apr 2013 01:05:56 -0700 (PDT)
From: Matteo <matteo.danieletto@gmail.com>
Content-Type: text/plain; charset=us-ascii
Subject: [b43] Station statistics 
Date: Wed, 10 Apr 2013 01:05:53 -0700
Message-Id: <10F448AB-C01E-4E57-906A-A702DB343AAA@gmail.com> (sfid-20130410_100606_028290_755C374A)
Cc: b43-dev@lists.infradead.org
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,
I am trying to find some data link statistics  like tx/rx packets, tx/rx
byte and
tx retries.

I found to use iw wlan0 station dump some interesting values, but I have a
doubt.

do you know why the #packets and bytes found with iw wlan0 station dump are different
if compared with cat /proc/net/dev ?

inactive time:    948 ms
   rx bytes:    12793798
   rx packets:    55705
   tx bytes:    72610
   tx packets:    377
   tx retries:    20
   tx failed:    2
   signal:      -33 dBm
   signal avg:    -33 dBm
   tx bitrate:    36.0 MBit/s
   authorized:    yes
   authenticated:    yes
   preamble:    long
   WMM/WME:    yes
   MFP:        no
   TDLS peer:        no


Inter-|   Receive                                                |  Transmit
face |bytes    packets errs drop fifo frame compressed multicast|bytes
packets errs drop fifo colls carrier compressed
   lo:  243244    1758    0    0    0     0          0         0
243244    1758    0    0    0     0       0          0
wlan0: 103605454  473003    0    0    0     0          0         0
1089910    6540    0    0    0     0       0          0