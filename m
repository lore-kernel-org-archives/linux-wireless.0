Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:62889 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbZG2TJ0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 15:09:26 -0400
Received: by ewy10 with SMTP id 10so213815ewy.37
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2009 12:09:26 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 29 Jul 2009 20:09:26 +0100
Message-ID: <2c8da8190907291209s73b39c26mca9c55e619164cc8@mail.gmail.com>
Subject: Beacon loss - broadcom 4318
From: =?ISO-8859-2?Q?J=EAdrek_Kaniewski?= <jedreky@googlemail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, I thought I eventually got my wireless to work but it is not very
reliable. So far I've noticed that it works during the night. It
hardly ever works during the day. The message I get is the following :

wlan0: beacon loss from AP f5ccb638 - sending probe request
wlan0: no probe response from AP f5ccb638 - disassociating
SFW2-OUT-ERROR IN= OUT=wlan0 SRC=192.168.0.16 DST=193.186.32.251
LEN=52 TOS=0x00 PREC=0x00 TTL=64 ID=42930 DF PROTO=TCP SPT=44714
DPT=80 WINDOW=998 RES=0x00 ACK PSH FIN URGP=0 OPT
(0101080A00076C6001CC5044)
wlan0: authenticate with AP f5ccb638
wlan0: authenticate with AP f5ccb638
wlan0: authenticated
wlan0: associate with AP f5ccb638
wlan0: RX ReassocResp from f59a903e (capab=0x431 status=0 aid=2)
wlan0: associated
SFW2-OUT-ERROR IN= OUT=wlan0 SRC=192.168.0.16 DST=193.186.32.251
LEN=52 TOS=0x00 PREC=0x00 TTL=64 ID=53851 DF PROTO=TCP SPT=44722
DPT=80 WINDOW=1002 RES=0x00 ACK PSH FIN URGP=0 OPT
(0101080A000773A001CC5048)
wlan0: beacon loss from AP f5ccb638 - sending probe request
wlan0: no probe response from AP f5ccb638 - disassociating

I googled and it seems that this problem is well known. However, I
didn't manage to find any workarounds.
Anyone could help ?

Cheers,
Jed
