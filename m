Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.242]:47858 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbXLDWF3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2007 17:05:29 -0500
Received: by an-out-0708.google.com with SMTP id d31so940078and
        for <linux-wireless@vger.kernel.org>; Tue, 04 Dec 2007 14:05:28 -0800 (PST)
Message-ID: <40f31dec0712041405sb14243dw9ccb7509e6f58d8@mail.gmail.com> (sfid-20071204_220535_496181_48553E5A)
Date: Wed, 5 Dec 2007 00:05:28 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Stefano Brivio" <stefano.brivio@polimi.it>
Subject: Re: [RFC][PATCH] mac80211: Use PID controller for TX rate control
Cc: "Mattias Nissler" <mattias.nissler@gmx.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Johannes Berg" <johannes@sipsolutions.net>
In-Reply-To: <20071204024146.15689ee3@morte>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1196622331.7472.4.camel@localhost> <20071203041608.3af3b462@morte>
	 <1196679780.7470.9.camel@localhost> <20071203125402.76562f26@morte>
	 <1196683144.7470.14.camel@localhost> <20071203130602.49ab7234@morte>
	 <40f31dec0712031442q51a658abwfde965dae3fb6b72@mail.gmail.com>
	 <20071204024146.15689ee3@morte>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There you go ;-)

5213
------

PID tuning test started at Tue Dec 4 23:51:34 EET 2007

rc_imul	rc_idiv	rc_pf	rc_p	rc_i	rc_d	rc_sm_s	rc_sh_s	rc_sh_d
1	1	 25	15	 10	15	 3	0	 0	
------------------------------------------------------------
Client connecting to 192.168.254.1, UDP port 5001
Sending 1470 byte datagrams
UDP buffer size:   106 KByte (default)
------------------------------------------------------------
[  3] local 192.168.254.8 port 39656 connected with 192.168.254.1 port 5001
[  3]  0.0- 1.0 sec    300 KBytes  2.46 Mbits/sec
[  3]  1.0- 2.0 sec    379 KBytes  3.10 Mbits/sec
[  3]  2.0- 3.0 sec    774 KBytes  6.34 Mbits/sec
[  3]  3.0- 4.0 sec  1.05 MBytes  8.80 Mbits/sec
[  3]  4.0- 5.0 sec  1.30 MBytes  10.9 Mbits/sec
[  3]  5.0- 6.0 sec  1.08 MBytes  9.03 Mbits/sec
[  3]  6.0- 7.0 sec    237 KBytes  1.94 Mbits/sec
[  3]  7.0- 8.0 sec    189 KBytes  1.55 Mbits/sec
[  3]  8.0- 9.0 sec    616 KBytes  5.05 Mbits/sec
[  3]  9.0-10.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 10.0-11.0 sec  94.7 KBytes    776 Kbits/sec
[  3] 11.0-12.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 12.0-13.0 sec    379 KBytes  3.10 Mbits/sec
[  3] 13.0-14.0 sec    663 KBytes  5.43 Mbits/sec
[  3] 14.0-15.0 sec    910 KBytes  7.46 Mbits/sec
[  3] 15.0-16.0 sec  1.03 MBytes  8.63 Mbits/sec
[  3] 16.0-17.0 sec  1012 KBytes  8.29 Mbits/sec
[  3] 17.0-18.0 sec    144 KBytes  1.18 Mbits/sec
[  3] 18.0-19.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 19.0-20.0 sec    521 KBytes  4.27 Mbits/sec
[  3] 20.0-21.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 21.0-22.0 sec  94.7 KBytes    776 Kbits/sec
[  3] 22.0-23.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 23.0-24.0 sec    379 KBytes  3.10 Mbits/sec
[  3] 24.0-25.0 sec    670 KBytes  5.49 Mbits/sec
[  3] 25.0-26.0 sec    887 KBytes  7.27 Mbits/sec
[  3] 26.0-27.0 sec  1.12 MBytes  9.42 Mbits/sec
[  3] 27.0-28.0 sec  1001 KBytes  8.20 Mbits/sec
[  3] 28.0-29.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 29.0-30.0 sec    237 KBytes  1.94 Mbits/sec
[  3] 30.0-31.0 sec    663 KBytes  5.43 Mbits/sec
[  3] 31.0-32.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 32.0-33.0 sec  94.7 KBytes    776 Kbits/sec
[  3] 33.0-34.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 34.0-35.0 sec    379 KBytes  3.10 Mbits/sec
[  3] 35.0-36.0 sec    758 KBytes  6.21 Mbits/sec
[  3] 36.0-37.0 sec  1.05 MBytes  8.78 Mbits/sec
[  3] 37.0-38.0 sec  1.27 MBytes  10.7 Mbits/sec
[  3] 38.0-39.0 sec  1.31 MBytes  11.0 Mbits/sec
[  3] 39.0-40.0 sec    197 KBytes  1.61 Mbits/sec
[  3] 40.0-41.0 sec    189 KBytes  1.55 Mbits/sec
[  3] 41.0-42.0 sec    474 KBytes  3.88 Mbits/sec
[  3] 42.0-43.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 43.0-44.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 44.0-45.0 sec  94.7 KBytes    776 Kbits/sec
[  3] 45.0-46.0 sec    379 KBytes  3.10 Mbits/sec
[  3] 46.0-47.0 sec    711 KBytes  5.82 Mbits/sec
[  3] 47.0-48.0 sec    933 KBytes  7.64 Mbits/sec
[  3] 48.0-49.0 sec  1.21 MBytes  10.2 Mbits/sec
[  3] 49.0-50.0 sec  1.15 MBytes  9.64 Mbits/sec
[  3] 50.0-51.0 sec    207 KBytes  1.69 Mbits/sec
[  3] 51.0-52.0 sec    189 KBytes  1.55 Mbits/sec
[  3] 52.0-53.0 sec    521 KBytes  4.27 Mbits/sec
[  3] 53.0-54.0 sec    189 KBytes  1.55 Mbits/sec
[  3] 54.0-55.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 55.0-56.0 sec  94.7 KBytes    776 Kbits/sec
[  3] 56.0-57.0 sec    332 KBytes  2.72 Mbits/sec
[  3] 57.0-58.0 sec    663 KBytes  5.43 Mbits/sec
[  3] 58.0-59.0 sec    962 KBytes  7.88 Mbits/sec
[  3] 59.0-60.0 sec  1.19 MBytes  9.98 Mbits/sec
[  3]  0.0-60.0 sec  31.4 MBytes  4.39 Mbits/sec
[  3] Sent 22396 datagrams
[  3] Server Report:
[  3]  0.0-60.0 sec  29.4 MBytes  4.11 Mbits/sec  3.242 ms 1413/22395 (6.3%)
[  3]  0.0-60.0 sec  1 datagrams received out-of-order

----

rc_imul	rc_idiv	rc_pf	rc_p	rc_i	rc_d	rc_sm_s	rc_sh_s	rc_sh_d
1	1	 25	15	 10	5	 3	0	 1	
------------------------------------------------------------
Client connecting to 192.168.254.1, UDP port 5001
Sending 1470 byte datagrams
UDP buffer size:   106 KByte (default)
------------------------------------------------------------
[  3] local 192.168.254.8 port 43701 connected with 192.168.254.1 port 5001
[  3]  0.0- 1.0 sec    297 KBytes  2.43 Mbits/sec
[  3]  1.0- 2.0 sec    426 KBytes  3.49 Mbits/sec
[  3]  2.0- 3.0 sec    827 KBytes  6.77 Mbits/sec
[  3]  3.0- 4.0 sec  1.07 MBytes  9.01 Mbits/sec
[  3]  4.0- 5.0 sec  1.42 MBytes  11.9 Mbits/sec
[  3]  5.0- 6.0 sec  1.31 MBytes  11.0 Mbits/sec
[  3]  6.0- 7.0 sec    237 KBytes  1.94 Mbits/sec
[  3]  7.0- 8.0 sec    237 KBytes  1.94 Mbits/sec
[  3]  8.0- 9.0 sec    680 KBytes  5.57 Mbits/sec
[  3]  9.0-10.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 10.0-11.0 sec  94.7 KBytes    776 Kbits/sec
[  3] 11.0-12.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 12.0-13.0 sec    426 KBytes  3.49 Mbits/sec
[  3] 13.0-14.0 sec    712 KBytes  5.83 Mbits/sec
[  3] 14.0-15.0 sec  1.01 MBytes  8.48 Mbits/sec
[  3] 15.0-16.0 sec  1.27 MBytes  10.6 Mbits/sec
[  3] 16.0-17.0 sec  1.27 MBytes  10.6 Mbits/sec
[  3] 17.0-18.0 sec    189 KBytes  1.55 Mbits/sec
[  3] 18.0-19.0 sec    189 KBytes  1.55 Mbits/sec
[  3] 19.0-20.0 sec    616 KBytes  5.05 Mbits/sec
[  3] 20.0-21.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 21.0-22.0 sec  94.7 KBytes    776 Kbits/sec
[  3] 22.0-23.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 23.0-24.0 sec    379 KBytes  3.10 Mbits/sec
[  3] 24.0-25.0 sec    711 KBytes  5.82 Mbits/sec
[  3] 25.0-26.0 sec  1002 KBytes  8.21 Mbits/sec
[  3] 26.0-27.0 sec  1.35 MBytes  11.3 Mbits/sec
[  3] 27.0-28.0 sec  1.27 MBytes  10.7 Mbits/sec
[  3] 28.0-29.0 sec    191 KBytes  1.56 Mbits/sec
[  3] 29.0-30.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 30.0-31.0 sec    426 KBytes  3.49 Mbits/sec
[  3] 31.0-32.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 32.0-33.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 33.0-34.0 sec  94.7 KBytes    776 Kbits/sec
[  3] 34.0-35.0 sec    379 KBytes  3.10 Mbits/sec
[  3] 35.0-36.0 sec    616 KBytes  5.05 Mbits/sec
[  3] 36.0-37.0 sec    805 KBytes  6.60 Mbits/sec
[  3] 37.0-38.0 sec    883 KBytes  7.23 Mbits/sec
[  3] 38.0-39.0 sec    843 KBytes  6.90 Mbits/sec
[  3] 39.0-40.0 sec    144 KBytes  1.18 Mbits/sec
[  3] 40.0-41.0 sec  94.7 KBytes    776 Kbits/sec
[  3] 41.0-42.0 sec    426 KBytes  3.49 Mbits/sec
[  3] 42.0-43.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 43.0-44.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 44.0-45.0 sec  94.7 KBytes    776 Kbits/sec
[  3] 45.0-46.0 sec    332 KBytes  2.72 Mbits/sec
[  3] 46.0-47.0 sec    568 KBytes  4.66 Mbits/sec
[  3] 47.0-48.0 sec    774 KBytes  6.34 Mbits/sec
[  3] 48.0-49.0 sec  1018 KBytes  8.34 Mbits/sec
[  3] 49.0-50.0 sec  1.24 MBytes  10.4 Mbits/sec
[  3] 50.0-51.0 sec    290 KBytes  2.38 Mbits/sec
[  3] 51.0-52.0 sec    237 KBytes  1.94 Mbits/sec
[  3] 52.0-53.0 sec    568 KBytes  4.66 Mbits/sec
[  3] 53.0-54.0 sec    189 KBytes  1.55 Mbits/sec
[  3] 54.0-55.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 55.0-56.0 sec  94.7 KBytes    776 Kbits/sec
[  3] 56.0-57.0 sec    379 KBytes  3.10 Mbits/sec
[  3] 57.0-58.0 sec    663 KBytes  5.43 Mbits/sec
[  3] 58.0-59.0 sec    975 KBytes  7.99 Mbits/sec
[  3] 59.0-60.0 sec  1.06 MBytes  8.87 Mbits/sec
[  3]  0.0-60.0 sec  31.4 MBytes  4.39 Mbits/sec
[  3] Sent 22431 datagrams
[  3] Server Report:
[  3]  0.0-60.0 sec  29.4 MBytes  4.11 Mbits/sec  4.439 ms 1430/22431 (6.4%)

----

rc_imul	rc_idiv	rc_pf	rc_p	rc_i	rc_d	rc_sm_s	rc_sh_s	rc_sh_d
1	1	 25	15	 10	5	 3	1	 1	
------------------------------------------------------------
Client connecting to 192.168.254.1, UDP port 5001
Sending 1470 byte datagrams
UDP buffer size:   106 KByte (default)
------------------------------------------------------------
[  3] local 192.168.254.8 port 34275 connected with 192.168.254.1 port 5001
[  3]  0.0- 1.0 sec    297 KBytes  2.43 Mbits/sec
[  3]  1.0- 2.0 sec    426 KBytes  3.49 Mbits/sec
[  3]  2.0- 3.0 sec    767 KBytes  6.28 Mbits/sec
[  3]  3.0- 4.0 sec  1.02 MBytes  8.60 Mbits/sec
[  3]  4.0- 5.0 sec  1.33 MBytes  11.1 Mbits/sec
[  3]  5.0- 6.0 sec  1.16 MBytes  9.71 Mbits/sec
[  3]  6.0- 7.0 sec    189 KBytes  1.55 Mbits/sec
[  3]  7.0- 8.0 sec    237 KBytes  1.94 Mbits/sec
[  3]  8.0- 9.0 sec    568 KBytes  4.66 Mbits/sec
[  3]  9.0-10.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 10.0-11.0 sec  94.7 KBytes    776 Kbits/sec
[  3] 11.0-12.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 12.0-13.0 sec    379 KBytes  3.10 Mbits/sec
[  3] 13.0-14.0 sec    711 KBytes  5.82 Mbits/sec
[  3] 14.0-15.0 sec    823 KBytes  6.74 Mbits/sec
[  3] 15.0-16.0 sec  1.06 MBytes  8.93 Mbits/sec
[  3] 16.0-17.0 sec  1.01 MBytes  8.47 Mbits/sec
[  3] 17.0-18.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 18.0-19.0 sec    189 KBytes  1.55 Mbits/sec
[  3] 19.0-20.0 sec    758 KBytes  6.21 Mbits/sec
[  3] 20.0-21.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 21.0-22.0 sec  94.7 KBytes    776 Kbits/sec
[  3] 22.0-23.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 23.0-24.0 sec    379 KBytes  3.10 Mbits/sec
[  3] 24.0-25.0 sec    758 KBytes  6.21 Mbits/sec
[  3] 25.0-26.0 sec  1.01 MBytes  8.47 Mbits/sec
[  3] 26.0-27.0 sec  1.29 MBytes  10.8 Mbits/sec
[  3] 27.0-28.0 sec  1.46 MBytes  12.3 Mbits/sec
[  3] 28.0-29.0 sec    189 KBytes  1.55 Mbits/sec
[  3] 29.0-30.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 30.0-31.0 sec    568 KBytes  4.66 Mbits/sec
[  3] 31.0-32.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 32.0-33.0 sec  94.7 KBytes    776 Kbits/sec
[  3] 33.0-34.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 34.0-35.0 sec    379 KBytes  3.10 Mbits/sec
[  3] 35.0-36.0 sec    663 KBytes  5.43 Mbits/sec
[  3] 36.0-37.0 sec    879 KBytes  7.20 Mbits/sec
[  3] 37.0-38.0 sec  1.13 MBytes  9.46 Mbits/sec
[  3] 38.0-39.0 sec  1.33 MBytes  11.2 Mbits/sec
[  3] 39.0-40.0 sec    306 KBytes  2.50 Mbits/sec
[  3] 40.0-41.0 sec    237 KBytes  1.94 Mbits/sec
[  3] 41.0-42.0 sec    580 KBytes  4.75 Mbits/sec
[  3] 42.0-43.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 43.0-44.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 44.0-45.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 45.0-46.0 sec    332 KBytes  2.72 Mbits/sec
[  3] 46.0-47.0 sec    758 KBytes  6.21 Mbits/sec
[  3] 47.0-48.0 sec  1018 KBytes  8.34 Mbits/sec
[  3] 48.0-49.0 sec  1.31 MBytes  10.9 Mbits/sec
[  3] 49.0-50.0 sec  1.43 MBytes  12.0 Mbits/sec
[  3] 50.0-51.0 sec    297 KBytes  2.43 Mbits/sec
[  3] 51.0-52.0 sec    189 KBytes  1.55 Mbits/sec
[  3] 52.0-53.0 sec    379 KBytes  3.10 Mbits/sec
[  3] 53.0-54.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 54.0-55.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 55.0-56.0 sec  94.7 KBytes    776 Kbits/sec
[  3] 56.0-57.0 sec    379 KBytes  3.10 Mbits/sec
[  3] 57.0-58.0 sec    711 KBytes  5.82 Mbits/sec
[  3] 58.0-59.0 sec    932 KBytes  7.63 Mbits/sec
[  3] 59.0-60.0 sec  1.06 MBytes  8.88 Mbits/sec
[  3]  0.0-60.0 sec  32.7 MBytes  4.57 Mbits/sec
[  3] Sent 23321 datagrams
[  3] Server Report:
[  3]  0.0-60.0 sec  30.5 MBytes  4.27 Mbits/sec  3.744 ms 1550/23321 (6.6%)

----

rc_imul	rc_idiv	rc_pf	rc_p	rc_i	rc_d	rc_sm_s	rc_sh_s	rc_sh_d
1	2	 25	15	 10	15	 3	0	 0	
------------------------------------------------------------
Client connecting to 192.168.254.1, UDP port 5001
Sending 1470 byte datagrams
UDP buffer size:   106 KByte (default)
------------------------------------------------------------
[  3] local 192.168.254.8 port 36709 connected with 192.168.254.1 port 5001
[  3]  0.0- 1.0 sec    992 KBytes  8.13 Mbits/sec
[  3]  1.0- 2.0 sec  1.35 MBytes  11.4 Mbits/sec
[  3]  2.0- 3.0 sec    191 KBytes  1.56 Mbits/sec
[  3]  3.0- 4.0 sec    474 KBytes  3.88 Mbits/sec
[  3]  4.0- 5.0 sec  94.7 KBytes    776 Kbits/sec
[  3]  5.0- 6.0 sec    436 KBytes  3.58 Mbits/sec
[  3]  6.0- 7.0 sec  1.18 MBytes  9.88 Mbits/sec
[  3]  7.0- 8.0 sec    828 KBytes  6.79 Mbits/sec
[  3]  8.0- 9.0 sec    474 KBytes  3.88 Mbits/sec
[  3]  9.0-10.0 sec    189 KBytes  1.55 Mbits/sec
[  3] 10.0-11.0 sec  94.7 KBytes    776 Kbits/sec
[  3] 11.0-12.0 sec    835 KBytes  6.84 Mbits/sec
[  3] 12.0-13.0 sec  1.38 MBytes  11.6 Mbits/sec
[  3] 13.0-14.0 sec    254 KBytes  2.08 Mbits/sec
[  3] 14.0-15.0 sec    426 KBytes  3.49 Mbits/sec
[  3] 15.0-16.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 16.0-17.0 sec    380 KBytes  3.12 Mbits/sec
[  3] 17.0-18.0 sec  1.11 MBytes  9.29 Mbits/sec
[  3] 18.0-19.0 sec    904 KBytes  7.41 Mbits/sec
[  3] 19.0-20.0 sec    379 KBytes  3.10 Mbits/sec
[  3] 20.0-21.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 21.0-22.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 22.0-23.0 sec    805 KBytes  6.60 Mbits/sec
[  3] 23.0-24.0 sec  1.35 MBytes  11.3 Mbits/sec
[  3] 24.0-25.0 sec    340 KBytes  2.79 Mbits/sec
[  3] 25.0-26.0 sec    521 KBytes  4.27 Mbits/sec
[  3] 26.0-27.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 27.0-28.0 sec    333 KBytes  2.73 Mbits/sec
[  3] 28.0-29.0 sec  1.14 MBytes  9.56 Mbits/sec
[  3] 29.0-30.0 sec  1019 KBytes  8.35 Mbits/sec
[  3] 30.0-31.0 sec    332 KBytes  2.72 Mbits/sec
[  3] 31.0-32.0 sec    237 KBytes  1.94 Mbits/sec
[  3] 32.0-33.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 33.0-34.0 sec    726 KBytes  5.95 Mbits/sec
[  3] 34.0-35.0 sec  1.40 MBytes  11.8 Mbits/sec
[  3] 35.0-36.0 sec    392 KBytes  3.21 Mbits/sec
[  3] 36.0-37.0 sec    332 KBytes  2.72 Mbits/sec
[  3] 37.0-38.0 sec  94.7 KBytes    776 Kbits/sec
[  3] 38.0-39.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 39.0-40.0 sec    627 KBytes  5.14 Mbits/sec
[  3] 40.0-41.0 sec  1.17 MBytes  9.78 Mbits/sec
[  3] 41.0-42.0 sec    401 KBytes  3.28 Mbits/sec
[  3] 42.0-43.0 sec    386 KBytes  3.16 Mbits/sec
[  3] 43.0-44.0 sec  94.7 KBytes    776 Kbits/sec
[  3] 44.0-45.0 sec    284 KBytes  2.33 Mbits/sec
[  3] 45.0-46.0 sec    917 KBytes  7.51 Mbits/sec
[  3] 46.0-47.0 sec  1001 KBytes  8.20 Mbits/sec
[  3] 47.0-48.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 48.0-49.0 sec    332 KBytes  2.72 Mbits/sec
[  3] 49.0-50.0 sec  94.7 KBytes    776 Kbits/sec
[  3] 50.0-51.0 sec    626 KBytes  5.13 Mbits/sec
[  3] 51.0-52.0 sec  1.15 MBytes  9.67 Mbits/sec
[  3] 52.0-53.0 sec    462 KBytes  3.79 Mbits/sec
[  3] 53.0-54.0 sec    426 KBytes  3.49 Mbits/sec
[  3] 54.0-55.0 sec  94.7 KBytes    776 Kbits/sec
[  3] 55.0-56.0 sec    189 KBytes  1.55 Mbits/sec
[  3] 56.0-57.0 sec    913 KBytes  7.48 Mbits/sec
[  3] 57.0-58.0 sec  1.05 MBytes  8.81 Mbits/sec
[  3] 58.0-59.0 sec    189 KBytes  1.55 Mbits/sec
[  3] 59.0-60.0 sec    240 KBytes  1.96 Mbits/sec
[  3]  0.0-60.3 sec  32.2 MBytes  4.48 Mbits/sec
[  3] Sent 22943 datagrams
[  3] Server Report:
[  3]  0.0-60.7 sec  29.7 MBytes  4.10 Mbits/sec  40.016 ms 1775/22943 (7.7%)

----

5413
------

PID tuning test started at Tue Dec 4 23:57:15 EET 2007

rc_imul	rc_idiv	rc_pf	rc_p	rc_i	rc_d	rc_sm_s	rc_sh_s	rc_sh_d
1	1	 25	15	 10	15	 3	0	 0	
------------------------------------------------------------
Client connecting to 192.168.254.1, UDP port 5001
Sending 1470 byte datagrams
UDP buffer size:   106 KByte (default)
------------------------------------------------------------
[  3] local 192.168.254.7 port 41135 connected with 192.168.254.1 port 5001
[  3]  0.0- 1.0 sec    683 KBytes  5.60 Mbits/sec
[  3]  1.0- 2.0 sec    983 KBytes  8.06 Mbits/sec
[  3]  2.0- 3.0 sec  1.30 MBytes  10.9 Mbits/sec
[  3]  3.0- 4.0 sec  1.41 MBytes  11.9 Mbits/sec
[  3]  4.0- 5.0 sec    690 KBytes  5.66 Mbits/sec
[  3]  5.0- 6.0 sec    237 KBytes  1.94 Mbits/sec
[  3]  6.0- 7.0 sec    474 KBytes  3.88 Mbits/sec
[  3]  7.0- 8.0 sec    584 KBytes  4.79 Mbits/sec
[  3]  8.0- 9.0 sec  94.7 KBytes    776 Kbits/sec
[  3]  9.0-10.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 10.0-11.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 11.0-12.0 sec    617 KBytes  5.06 Mbits/sec
[  3] 12.0-13.0 sec    924 KBytes  7.57 Mbits/sec
[  3] 13.0-14.0 sec  1.29 MBytes  10.8 Mbits/sec
[  3] 14.0-15.0 sec  1.57 MBytes  13.1 Mbits/sec
[  3] 15.0-16.0 sec  1.18 MBytes  9.87 Mbits/sec
[  3] 16.0-17.0 sec    284 KBytes  2.33 Mbits/sec
[  3] 17.0-18.0 sec    379 KBytes  3.10 Mbits/sec
[  3] 18.0-19.0 sec    577 KBytes  4.73 Mbits/sec
[  3] 19.0-20.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 20.0-21.0 sec  94.7 KBytes    776 Kbits/sec
[  3] 21.0-22.0 sec    189 KBytes  1.55 Mbits/sec
[  3] 22.0-23.0 sec    568 KBytes  4.66 Mbits/sec
[  3] 23.0-24.0 sec    968 KBytes  7.93 Mbits/sec
[  3] 24.0-25.0 sec  1.28 MBytes  10.7 Mbits/sec
[  3] 25.0-26.0 sec  1.57 MBytes  13.2 Mbits/sec
[  3] 26.0-27.0 sec  1.19 MBytes  10.0 Mbits/sec
[  3] 27.0-28.0 sec    241 KBytes  1.98 Mbits/sec
[  3] 28.0-29.0 sec    428 KBytes  3.50 Mbits/sec
[  3] 29.0-30.0 sec    620 KBytes  5.08 Mbits/sec
[  3] 30.0-31.0 sec  94.7 KBytes    776 Kbits/sec
[  3] 31.0-32.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 32.0-33.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 33.0-34.0 sec    616 KBytes  5.05 Mbits/sec
[  3] 34.0-35.0 sec    900 KBytes  7.37 Mbits/sec
[  3] 35.0-36.0 sec  1.26 MBytes  10.5 Mbits/sec
[  3] 36.0-37.0 sec  1.66 MBytes  14.0 Mbits/sec
[  3] 37.0-38.0 sec  1.36 MBytes  11.4 Mbits/sec
[  3] 38.0-39.0 sec    237 KBytes  1.94 Mbits/sec
[  3] 39.0-40.0 sec    332 KBytes  2.72 Mbits/sec
[  3] 40.0-41.0 sec    679 KBytes  5.56 Mbits/sec
[  3] 41.0-42.0 sec  94.7 KBytes    776 Kbits/sec
[  3] 42.0-43.0 sec  94.7 KBytes    776 Kbits/sec
[  3] 43.0-44.0 sec    189 KBytes  1.55 Mbits/sec
[  3] 44.0-45.0 sec    524 KBytes  4.29 Mbits/sec
[  3] 45.0-46.0 sec    926 KBytes  7.59 Mbits/sec
[  3] 46.0-47.0 sec  1.26 MBytes  10.5 Mbits/sec
[  3] 47.0-48.0 sec  1.67 MBytes  14.0 Mbits/sec
[  3] 48.0-49.0 sec  1.39 MBytes  11.6 Mbits/sec
[  3] 49.0-50.0 sec    284 KBytes  2.33 Mbits/sec
[  3] 50.0-51.0 sec    237 KBytes  1.94 Mbits/sec
[  3] 51.0-52.0 sec    474 KBytes  3.88 Mbits/sec
[  3] 52.0-53.0 sec  94.7 KBytes    776 Kbits/sec
[  3] 53.0-54.0 sec  94.7 KBytes    776 Kbits/sec
[  3] 54.0-55.0 sec    189 KBytes  1.55 Mbits/sec
[  3] 55.0-56.0 sec    568 KBytes  4.66 Mbits/sec
[  3] 56.0-57.0 sec    900 KBytes  7.37 Mbits/sec
[  3] 57.0-58.0 sec  1.21 MBytes  10.2 Mbits/sec
[  3] 58.0-59.0 sec  1.67 MBytes  14.0 Mbits/sec
[  3] 59.0-60.0 sec  1.48 MBytes  12.4 Mbits/sec
[  3]  0.0-60.1 sec  41.2 MBytes  5.76 Mbits/sec
[  3] Sent 29394 datagrams
[  3] Server Report:
[  3]  0.0-62.0 sec  38.2 MBytes  5.17 Mbits/sec  122.648 ms 2145/29394 (7.3%)

----

rc_imul	rc_idiv	rc_pf	rc_p	rc_i	rc_d	rc_sm_s	rc_sh_s	rc_sh_d
1	1	 25	15	 10	5	 3	0	 1	
------------------------------------------------------------
Client connecting to 192.168.254.1, UDP port 5001
Sending 1470 byte datagrams
UDP buffer size:   106 KByte (default)
------------------------------------------------------------
[  3] local 192.168.254.7 port 49566 connected with 192.168.254.1 port 5001
[  3]  0.0- 1.0 sec    943 KBytes  7.73 Mbits/sec
[  3]  1.0- 2.0 sec  1.13 MBytes  9.49 Mbits/sec
[  3]  2.0- 3.0 sec  1.55 MBytes  13.0 Mbits/sec
[  3]  3.0- 4.0 sec  1.94 MBytes  16.3 Mbits/sec
[  3]  4.0- 5.0 sec    240 KBytes  1.96 Mbits/sec
[  3]  5.0- 6.0 sec    284 KBytes  2.33 Mbits/sec
[  3]  6.0- 7.0 sec    716 KBytes  5.87 Mbits/sec
[  3]  7.0- 8.0 sec    142 KBytes  1.16 Mbits/sec
[  3]  8.0- 9.0 sec  94.7 KBytes    776 Kbits/sec
[  3]  9.0-10.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 10.0-11.0 sec    379 KBytes  3.10 Mbits/sec
[  3] 11.0-12.0 sec    853 KBytes  6.99 Mbits/sec
[  3] 12.0-13.0 sec  1.10 MBytes  9.20 Mbits/sec
[  3] 13.0-14.0 sec  1.56 MBytes  13.1 Mbits/sec
[  3] 14.0-15.0 sec  1.92 MBytes  16.1 Mbits/sec
[  3] 15.0-16.0 sec    326 KBytes  2.67 Mbits/sec
[  3] 16.0-17.0 sec    237 KBytes  1.94 Mbits/sec
[  3] 17.0-18.0 sec    189 KBytes  1.55 Mbits/sec
[  3] 18.0-19.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 19.0-20.0 sec  94.7 KBytes    776 Kbits/sec
[  3] 20.0-21.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 21.0-22.0 sec  94.7 KBytes    776 Kbits/sec
[  3] 22.0-23.0 sec    379 KBytes  3.10 Mbits/sec
[  3] 23.0-24.0 sec    758 KBytes  6.21 Mbits/sec
[  3] 24.0-25.0 sec  1.12 MBytes  9.38 Mbits/sec
[  3] 25.0-26.0 sec  1.54 MBytes  12.9 Mbits/sec
[  3] 26.0-27.0 sec  1.94 MBytes  16.3 Mbits/sec
[  3] 27.0-28.0 sec    393 KBytes  3.22 Mbits/sec
[  3] 28.0-29.0 sec    237 KBytes  1.94 Mbits/sec
[  3] 29.0-30.0 sec    672 KBytes  5.50 Mbits/sec
[  3] 30.0-31.0 sec    189 KBytes  1.55 Mbits/sec
[  3] 31.0-32.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 32.0-33.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 33.0-34.0 sec    379 KBytes  3.10 Mbits/sec
[  3] 34.0-35.0 sec    758 KBytes  6.21 Mbits/sec
[  3] 35.0-36.0 sec  1.08 MBytes  9.04 Mbits/sec
[  3] 36.0-37.0 sec  1.55 MBytes  13.0 Mbits/sec
[  3] 37.0-38.0 sec  1.93 MBytes  16.2 Mbits/sec
[  3] 38.0-39.0 sec    369 KBytes  3.02 Mbits/sec
[  3] 39.0-40.0 sec    238 KBytes  1.95 Mbits/sec
[  3] 40.0-41.0 sec    672 KBytes  5.50 Mbits/sec
[  3] 41.0-42.0 sec    240 KBytes  1.96 Mbits/sec
[  3] 42.0-43.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 43.0-44.0 sec  94.7 KBytes    776 Kbits/sec
[  3] 44.0-45.0 sec    379 KBytes  3.10 Mbits/sec
[  3] 45.0-46.0 sec    758 KBytes  6.21 Mbits/sec
[  3] 46.0-47.0 sec  1.06 MBytes  8.93 Mbits/sec
[  3] 47.0-48.0 sec  1.50 MBytes  12.6 Mbits/sec
[  3] 48.0-49.0 sec  1.93 MBytes  16.2 Mbits/sec
[  3] 49.0-50.0 sec    451 KBytes  3.69 Mbits/sec
[  3] 50.0-51.0 sec    237 KBytes  1.94 Mbits/sec
[  3] 51.0-52.0 sec    900 KBytes  7.37 Mbits/sec
[  3] 52.0-53.0 sec    297 KBytes  2.43 Mbits/sec
[  3] 53.0-54.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 54.0-55.0 sec  94.7 KBytes    776 Kbits/sec
[  3] 55.0-56.0 sec    379 KBytes  3.10 Mbits/sec
[  3] 56.0-57.0 sec    758 KBytes  6.21 Mbits/sec
[  3] 57.0-58.0 sec  1.07 MBytes  8.98 Mbits/sec
[  3] 58.0-59.0 sec  1.47 MBytes  12.4 Mbits/sec
[  3] 59.0-60.0 sec  1.90 MBytes  16.0 Mbits/sec
[  3]  0.0-60.0 sec  42.2 MBytes  5.89 Mbits/sec
[  3] Sent 30077 datagrams
[  3] Server Report:
[  3]  0.0-60.0 sec  39.6 MBytes  5.54 Mbits/sec  1.989 ms 1813/30077 (6%)

----

rc_imul	rc_idiv	rc_pf	rc_p	rc_i	rc_d	rc_sm_s	rc_sh_s	rc_sh_d
1	1	 25	15	 10	5	 3	1	 1	
------------------------------------------------------------
Client connecting to 192.168.254.1, UDP port 5001
Sending 1470 byte datagrams
UDP buffer size:   106 KByte (default)
------------------------------------------------------------
[  3] local 192.168.254.7 port 54622 connected with 192.168.254.1 port 5001
[  3]  0.0- 1.0 sec    825 KBytes  6.76 Mbits/sec
[  3]  1.0- 2.0 sec  1.08 MBytes  9.02 Mbits/sec
[  3]  2.0- 3.0 sec  1.49 MBytes  12.5 Mbits/sec
[  3]  3.0- 4.0 sec  1.90 MBytes  15.9 Mbits/sec
[  3]  4.0- 5.0 sec    511 KBytes  4.19 Mbits/sec
[  3]  5.0- 6.0 sec    189 KBytes  1.55 Mbits/sec
[  3]  6.0- 7.0 sec    666 KBytes  5.46 Mbits/sec
[  3]  7.0- 8.0 sec    289 KBytes  2.36 Mbits/sec
[  3]  8.0- 9.0 sec  94.7 KBytes    776 Kbits/sec
[  3]  9.0-10.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 10.0-11.0 sec    332 KBytes  2.72 Mbits/sec
[  3] 11.0-12.0 sec    758 KBytes  6.21 Mbits/sec
[  3] 12.0-13.0 sec  1.05 MBytes  8.81 Mbits/sec
[  3] 13.0-14.0 sec  1.48 MBytes  12.4 Mbits/sec
[  3] 14.0-15.0 sec  1.86 MBytes  15.6 Mbits/sec
[  3] 15.0-16.0 sec    553 KBytes  4.53 Mbits/sec
[  3] 16.0-17.0 sec    191 KBytes  1.56 Mbits/sec
[  3] 17.0-18.0 sec    853 KBytes  6.99 Mbits/sec
[  3] 18.0-19.0 sec    379 KBytes  3.10 Mbits/sec
[  3] 19.0-20.0 sec  94.7 KBytes    776 Kbits/sec
[  3] 20.0-21.0 sec    144 KBytes  1.18 Mbits/sec
[  3] 21.0-22.0 sec    332 KBytes  2.72 Mbits/sec
[  3] 22.0-23.0 sec    722 KBytes  5.92 Mbits/sec
[  3] 23.0-24.0 sec  1.02 MBytes  8.56 Mbits/sec
[  3] 24.0-25.0 sec  1.46 MBytes  12.3 Mbits/sec
[  3] 25.0-26.0 sec  1.83 MBytes  15.4 Mbits/sec
[  3] 26.0-27.0 sec    678 KBytes  5.55 Mbits/sec
[  3] 27.0-28.0 sec    145 KBytes  1.19 Mbits/sec
[  3] 28.0-29.0 sec    711 KBytes  5.82 Mbits/sec
[  3] 29.0-30.0 sec    474 KBytes  3.88 Mbits/sec
[  3] 30.0-31.0 sec  94.7 KBytes    776 Kbits/sec
[  3] 31.0-32.0 sec  94.7 KBytes    776 Kbits/sec
[  3] 32.0-33.0 sec    332 KBytes  2.72 Mbits/sec
[  3] 33.0-34.0 sec    719 KBytes  5.89 Mbits/sec
[  3] 34.0-35.0 sec  1.02 MBytes  8.58 Mbits/sec
[  3] 35.0-36.0 sec  1.43 MBytes  12.0 Mbits/sec
[  3] 36.0-37.0 sec  1.82 MBytes  15.2 Mbits/sec
[  3] 37.0-38.0 sec    725 KBytes  5.94 Mbits/sec
[  3] 38.0-39.0 sec  96.2 KBytes    788 Kbits/sec
[  3] 39.0-40.0 sec    711 KBytes  5.82 Mbits/sec
[  3] 40.0-41.0 sec    521 KBytes  4.27 Mbits/sec
[  3] 41.0-42.0 sec  94.7 KBytes    776 Kbits/sec
[  3] 42.0-43.0 sec  94.7 KBytes    776 Kbits/sec
[  3] 43.0-44.0 sec    284 KBytes  2.33 Mbits/sec
[  3] 44.0-45.0 sec    711 KBytes  5.82 Mbits/sec
[  3] 45.0-46.0 sec  1.01 MBytes  8.49 Mbits/sec
[  3] 46.0-47.0 sec  1.39 MBytes  11.6 Mbits/sec
[  3] 47.0-48.0 sec  1.85 MBytes  15.5 Mbits/sec
[  3] 48.0-49.0 sec    877 KBytes  7.19 Mbits/sec
[  3] 49.0-50.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 50.0-51.0 sec    850 KBytes  6.96 Mbits/sec
[  3] 51.0-52.0 sec    762 KBytes  6.24 Mbits/sec
[  3] 52.0-53.0 sec  94.7 KBytes    776 Kbits/sec
[  3] 53.0-54.0 sec  94.7 KBytes    776 Kbits/sec
[  3] 54.0-55.0 sec    284 KBytes  2.33 Mbits/sec
[  3] 55.0-56.0 sec    663 KBytes  5.43 Mbits/sec
[  3] 56.0-57.0 sec  1.01 MBytes  8.44 Mbits/sec
[  3] 57.0-58.0 sec  1.36 MBytes  11.4 Mbits/sec
[  3] 58.0-59.0 sec  1.81 MBytes  15.2 Mbits/sec
[  3] 59.0-60.0 sec    995 KBytes  8.15 Mbits/sec
[  3]  0.0-60.5 sec  43.8 MBytes  6.07 Mbits/sec
[  3] Sent 31217 datagrams
[  3] Server Report:
[  3]  0.0-61.7 sec  42.0 MBytes  5.72 Mbits/sec  52.465 ms 1226/31217 (3.9%)

----

rc_imul	rc_idiv	rc_pf	rc_p	rc_i	rc_d	rc_sm_s	rc_sh_s	rc_sh_d
1	2	 25	15	 10	15	 3	0	 0	
------------------------------------------------------------
Client connecting to 192.168.254.1, UDP port 5001
Sending 1470 byte datagrams
UDP buffer size:   106 KByte (default)
------------------------------------------------------------
[  3] local 192.168.254.7 port 44058 connected with 192.168.254.1 port 5001
[  3]  0.0- 1.0 sec  1.80 MBytes  15.1 Mbits/sec
[  3]  1.0- 2.0 sec  96.2 KBytes    788 Kbits/sec
[  3]  2.0- 3.0 sec    734 KBytes  6.01 Mbits/sec
[  3]  3.0- 4.0 sec  94.7 KBytes    776 Kbits/sec
[  3]  4.0- 5.0 sec    521 KBytes  4.27 Mbits/sec
[  3]  5.0- 6.0 sec  1.33 MBytes  11.2 Mbits/sec
[  3]  6.0- 7.0 sec  1.11 MBytes  9.33 Mbits/sec
[  3]  7.0- 8.0 sec    189 KBytes  1.55 Mbits/sec
[  3]  8.0- 9.0 sec    142 KBytes  1.16 Mbits/sec
[  3]  9.0-10.0 sec  94.7 KBytes    776 Kbits/sec
[  3] 10.0-11.0 sec  94.7 KBytes    776 Kbits/sec
[  3] 11.0-12.0 sec    332 KBytes  2.72 Mbits/sec
[  3] 12.0-13.0 sec  1.22 MBytes  10.2 Mbits/sec
[  3] 13.0-14.0 sec  1.32 MBytes  11.0 Mbits/sec
[  3] 14.0-15.0 sec    339 KBytes  2.78 Mbits/sec
[  3] 15.0-16.0 sec  1.03 MBytes  8.68 Mbits/sec
[  3] 16.0-17.0 sec  1.20 MBytes  10.1 Mbits/sec
[  3] 17.0-18.0 sec  1.29 MBytes  10.8 Mbits/sec
[  3] 18.0-19.0 sec    144 KBytes  1.18 Mbits/sec
[  3] 19.0-20.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 20.0-21.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 21.0-22.0 sec  94.7 KBytes    776 Kbits/sec
[  3] 22.0-23.0 sec    758 KBytes  6.21 Mbits/sec
[  3] 23.0-24.0 sec  1.54 MBytes  12.9 Mbits/sec
[  3] 24.0-25.0 sec    666 KBytes  5.46 Mbits/sec
[  3] 25.0-26.0 sec    627 KBytes  5.14 Mbits/sec
[  3] 26.0-27.0 sec    332 KBytes  2.72 Mbits/sec
[  3] 27.0-28.0 sec    769 KBytes  6.30 Mbits/sec
[  3] 28.0-29.0 sec  1.48 MBytes  12.4 Mbits/sec
[  3] 29.0-30.0 sec    711 KBytes  5.82 Mbits/sec
[  3] 30.0-31.0 sec    873 KBytes  7.15 Mbits/sec
[  3] 31.0-32.0 sec    521 KBytes  4.27 Mbits/sec
[  3] 32.0-33.0 sec  1.08 MBytes  9.09 Mbits/sec
[  3] 33.0-34.0 sec  1.54 MBytes  12.9 Mbits/sec
[  3] 34.0-35.0 sec    238 KBytes  1.95 Mbits/sec
[  3] 35.0-36.0 sec  1013 KBytes  8.30 Mbits/sec
[  3] 36.0-37.0 sec    711 KBytes  5.82 Mbits/sec
[  3] 37.0-38.0 sec  1.51 MBytes  12.7 Mbits/sec
[  3] 38.0-39.0 sec    722 KBytes  5.92 Mbits/sec
[  3] 39.0-40.0 sec    533 KBytes  4.36 Mbits/sec
[  3] 40.0-41.0 sec    637 KBytes  5.22 Mbits/sec
[  3] 41.0-42.0 sec  1.08 MBytes  9.08 Mbits/sec
[  3] 42.0-43.0 sec  1.59 MBytes  13.3 Mbits/sec
[  3] 43.0-44.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 44.0-45.0 sec    284 KBytes  2.33 Mbits/sec
[  3] 45.0-46.0 sec  94.7 KBytes    776 Kbits/sec
[  3] 46.0-47.0 sec    189 KBytes  1.55 Mbits/sec
[  3] 47.0-48.0 sec    992 KBytes  8.13 Mbits/sec
[  3] 48.0-49.0 sec  1.72 MBytes  14.4 Mbits/sec
[  3] 49.0-50.0 sec  94.7 KBytes    776 Kbits/sec
[  3] 50.0-51.0 sec    189 KBytes  1.55 Mbits/sec
[  3] 51.0-52.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 52.0-53.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 53.0-54.0 sec    900 KBytes  7.37 Mbits/sec
[  3] 54.0-55.0 sec  1.74 MBytes  14.6 Mbits/sec
[  3] 55.0-56.0 sec    251 KBytes  2.06 Mbits/sec
[  3] 56.0-57.0 sec    191 KBytes  1.56 Mbits/sec
[  3] 57.0-58.0 sec    202 KBytes  1.66 Mbits/sec
[  3] 58.0-59.0 sec    142 KBytes  1.16 Mbits/sec
[  3] 59.0-60.0 sec    853 KBytes  6.99 Mbits/sec
[  3]  0.0-60.0 sec  40.3 MBytes  5.63 Mbits/sec
[  3] Sent 28732 datagrams
[  3] Server Report:
[  3]  0.0-60.0 sec  39.0 MBytes  5.44 Mbits/sec  4.127 ms  939/28732 (3.3%)

----

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
