Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:52217 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758615AbbBGTO2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Feb 2015 14:14:28 -0500
Message-ID: <54D6640A.8030104@gmx.net> (sfid-20150207_201431_679379_830B749A)
Date: Sat, 07 Feb 2015 19:14:18 +0000
From: Benjamin Adler <benadler@gmx.net>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: brcm80211 development <brcm80211-dev-list@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: BCM4330 linux support
References: <54D3FF89.502@phoenix-aerial.com> <54D4851F.8020402@broadcom.com> <54D4D37C.2060007@phoenix-aerial.com> <54D4E509.3090308@broadcom.com> <54D57031.9090903@gmx.net> <54D6558B.4010500@broadcom.com>
In-Reply-To: <54D6558B.4010500@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07.02.2015 18:12, Arend van Spriel wrote:
> Can you do a hexdump of your firmware image, ie.:
> hexdump -C 4330rtecdc.bin | tail -20

0003abb0  00 50 65 00 e8 5e 8f 00  37 a3 00 68 de 8f 00 13 
|.Pe..^..7..h....|
0003abc0  f1 00 02 de 02 f0 00 00  02 02 00 bf 00 01 a9 02 
|................|
0003abd0  03 c5 73 00 01 d2 00 00  00 00 00 00 00 00 00 00 
|..s.............|
0003abe0  f9 8b 00 00 62 65 e3 66  05 61 27 04 b0 cc e8 52 
|....be.f.a'....R|
0003abf0  41 5b 07 3e 66 47 78 49  08 45 1d 79 7f 09 28 75 
|A[.>fGxI.E.y..(u|
0003ac00  d7 b9 c7 13 01 bd 32 08  01 00 34 33 33 30 62 32 
|......2...4330b2|
0003ac10  2d 72 6f 6d 6c 2f 73 64  69 6f 2d 61 67 2d 6e 64 
|-roml/sdio-ag-nd|
0003ac20  69 73 2d 76 69 73 74 61  2d 70 6b 74 66 69 6c 74 
|is-vista-pktfilt|
0003ac30  65 72 2d 64 30 63 2d 70  6e 6f 2d 61 6f 65 2d 70 
|er-d0c-pno-aoe-p|
0003ac40  32 70 2d 64 68 64 6f 69  64 2d 6e 64 6f 65 2d 77 
|2p-dhdoid-ndoe-w|
0003ac50  6c 6d 66 70 2d 61 70 2d  6b 65 65 70 61 6c 69 76 
|lmfp-ap-keepaliv|
0003ac60  65 2d 73 61 66 65 2d 64  73 74 61 2d 6d 63 68 61 
|e-safe-dsta-mcha|
0003ac70  6e 2d 77 69 6e 38 6d 65  6d 6f 70 74 20 56 65 72 
|n-win8memopt Ver|
0003ac80  73 69 6f 6e 3a 20 35 2e  39 37 2e 33 39 2e 34 20  |sion: 
5.97.39.4 |
0003ac90  43 52 43 3a 20 39 39 31  63 39 61 39 64 20 44 61  |CRC: 
991c9a9d Da|
0003aca0  74 65 3a 20 57 65 64 20  32 30 31 34 2d 30 31 2d  |te: Wed 
2014-01-|
0003acb0  32 39 20 30 31 3a 34 31  3a 30 34 20 50 53 54 20  |29 01:41:04 
PST |
0003acc0  46 57 49 44 20 30 31 2d  63 37 62 39 64 37 37 35  |FWID 
01-c7b9d775|
0003acd0  0a 00 c8 00                                       |....|

Is -ap- what I'm looking for?

Cheers,
Ben
