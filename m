Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:39358 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbYHGF0g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 01:26:36 -0400
Received: by wf-out-1314.google.com with SMTP id 27so475704wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 06 Aug 2008 22:26:34 -0700 (PDT)
Message-ID: <1197ff4c0808062226i2f435122g2b611074dfd81ab6@mail.gmail.com> (sfid-20080807_072645_996806_F85CE977)
Date: Thu, 7 Aug 2008 13:26:34 +0800
From: YanBo <dreamfly281@gmail.com>
To: wireless <linux-wireless@vger.kernel.org>
Subject: Ath5k (AR2413) mesh performance test (two nodes)
Cc: "Luis Carlos Cobo" <luisca@cozybit.com>,
	ath5k-devel@lists.ath5k.org
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I used two AR2413 card worked in mesh mode, and using the newest
wireless-testing tree,  by disable the kernel debugging option to
avoid trigger some "Lock" problem will hang up the system,  the two
AR2413 can find each other in mesh mode and connect to each other.
then I use iperf to test the performance between them. (the distance
between two mesh node is less than 1 meter, in a noisy environment )

------------------------------------------------------------
Server listening on TCP port 5001
TCP window size: 85.3 KByte (default)
------------------------------------------------------------
[  4] local 13.1.1.2 port 5001 connected with 13.1.1.1 port 32905
[  4]  0.0- 1.0 sec  99.4 KBytes    814 Kbits/sec
[  4]  1.0- 2.0 sec    298 KBytes  2.44 Mbits/sec
[  4]  2.0- 3.0 sec    102 KBytes    834 Kbits/sec
[  4]  3.0- 4.0 sec    170 KBytes  1.39 Mbits/sec
[  4]  4.0- 5.0 sec  0.00 Bytes  0.00 bits/sec
[  4]  5.0- 6.0 sec    106 KBytes    869 Kbits/sec
[  4]  6.0- 7.0 sec  0.00 Bytes  0.00 bits/sec
[  4]  7.0- 8.0 sec  53.7 KBytes    440 Kbits/sec
[  4]  8.0- 9.0 sec    341 KBytes  2.79 Mbits/sec
[  4]  9.0-10.0 sec    273 KBytes  2.24 Mbits/sec
[  4] 10.0-11.0 sec  94.7 KBytes    776 Kbits/sec
[  4] 11.0-12.0 sec    547 KBytes  4.48 Mbits/sec
[  4] 12.0-13.0 sec  50.9 KBytes    417 Kbits/sec
[  4] 13.0-14.0 sec    109 KBytes    892 Kbits/sec
[  4] 14.0-15.0 sec    505 KBytes  4.14 Mbits/sec
[  4] 15.0-16.0 sec  46.7 KBytes    382 Kbits/sec
[  4] 16.0-17.0 sec  0.00 Bytes  0.00 bits/sec
[  4] 17.0-18.0 sec  59.4 KBytes    487 Kbits/sec
[  4] 18.0-19.0 sec    474 KBytes  3.88 Mbits/sec
[  4] 19.0-20.0 sec    124 KBytes  1.02 Mbits/sec
[  4] 20.0-21.0 sec  22.6 KBytes    185 Kbits/sec
[  4] 21.0-22.0 sec    410 KBytes  3.36 Mbits/sec
[  4] 22.0-23.0 sec  99.0 KBytes    811 Kbits/sec
[  4] 23.0-24.0 sec  26.9 KBytes    220 Kbits/sec
[  4] 24.0-25.0 sec    296 KBytes  2.42 Mbits/sec
[  4] 25.0-26.0 sec    160 KBytes  1.31 Mbits/sec
[  4] 26.0-27.0 sec    148 KBytes  1.22 Mbits/sec
[  4] 27.0-28.0 sec  0.00 Bytes  0.00 bits/sec
[  4] 28.0-29.0 sec    238 KBytes  1.95 Mbits/sec
[  4] 29.0-30.0 sec    100 KBytes    822 Kbits/sec
[  4] 30.0-31.0 sec    185 KBytes  1.52 Mbits/sec
[  4] 31.0-32.0 sec  0.00 Bytes  0.00 bits/sec
[  4] 32.0-33.0 sec  0.00 Bytes  0.00 bits/sec
[  4] 33.0-34.0 sec  2.83 KBytes  23.2 Kbits/sec
[  4] 34.0-35.0 sec  0.00 Bytes  0.00 bits/sec
[  4] 35.0-36.0 sec  49.5 KBytes    405 Kbits/sec
[  4] 36.0-37.0 sec    358 KBytes  2.93 Mbits/sec
[  4] 37.0-38.0 sec    311 KBytes  2.55 Mbits/sec
[  4] 38.0-39.0 sec  1.41 KBytes  11.6 Kbits/sec
[  4] 39.0-40.0 sec  45.2 KBytes    371 Kbits/sec
[  4] 40.0-41.0 sec    426 KBytes  3.49 Mbits/sec
[  4] 41.0-42.0 sec    151 KBytes  1.24 Mbits/sec
[  4] 42.0-43.0 sec  18.4 KBytes    151 Kbits/sec
[  4] 43.0-44.0 sec    201 KBytes  1.64 Mbits/sec
[  4] 44.0-45.0 sec    370 KBytes  3.04 Mbits/sec
[  4] 45.0-46.0 sec  91.9 KBytes    753 Kbits/sec
[  4] 46.0-47.0 sec  11.3 KBytes  92.7 Kbits/sec
[  4] 47.0-48.0 sec  59.4 KBytes    487 Kbits/sec
[  4] 48.0-49.0 sec    380 KBytes  3.12 Mbits/sec
[  4] 49.0-50.0 sec  97.6 KBytes    799 Kbits/sec
[  4] 50.0-51.0 sec  15.6 KBytes    127 Kbits/sec
[  4]  0.0-51.6 sec  7.61 MBytes  1.24 Mbits/sec
