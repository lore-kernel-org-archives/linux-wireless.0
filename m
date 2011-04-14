Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33041 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757643Ab1DNT1X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2011 15:27:23 -0400
Received: by bwz15 with SMTP id 15so1644344bwz.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Apr 2011 12:27:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201104142106.48549.chunkeey@googlemail.com>
References: <BANLkTimreffpSdBUogakk=E6Hn1Lf6KJ_w@mail.gmail.com>
 <BANLkTi=gTS5DvT+JMr35Q4puaqUaUy5Bww@mail.gmail.com> <BANLkTik2F_6w5jacYw+2-=7Jken6aF_RBQ@mail.gmail.com>
 <201104142106.48549.chunkeey@googlemail.com>
From: Damian Lesiuk <lesiuk@gmail.com>
Date: Thu, 14 Apr 2011 21:26:42 +0200
Message-ID: <BANLkTi=HaJ0ZrtmDo=wwBOrEweZrjHqWXw@mail.gmail.com>
Subject: Re: carl9170: TP-LINK TL-WN822N slow connection speeds (16 mbps)
 MASTER MODE
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hostapd log with -dd option.

I dont see any operation not permitted.

wlan0: STA 74:f0:6d:33:ea:00 IEEE 802.11: authentication OK (open system)
wlan0: STA 74:f0:6d:33:ea:00 MLME:
MLME-AUTHENTICATE.indication(74:f0:6d:33:ea:00, OPEN_SYSTEM)
wlan0: STA 74:f0:6d:33:ea:00 MLME: MLME-DELETEKEYS.request(74:f0:6d:33:ea:00)
wlan0: STA 74:f0:6d:33:ea:00 IEEE 802.11: authenticated
wlan0: STA 74:f0:6d:33:ea:00 IEEE 802.11: association OK (aid 1)
wlan0: STA 74:f0:6d:33:ea:00 IEEE 802.11: associated (aid 1)
wlan0: STA 74:f0:6d:33:ea:00 MLME: MLME-ASSOCIATE.indication(74:f0:6d:33:ea:00)
wlan0: STA 74:f0:6d:33:ea:00 MLME: MLME-DELETEKEYS.request(74:f0:6d:33:ea:00)
wlan0: STA 74:f0:6d:33:ea:00 WPA: event 1 notification
wlan0: STA 74:f0:6d:33:ea:00 WPA: start authentication
wlan0: STA 74:f0:6d:33:ea:00 IEEE 802.1X: unauthorizing port
wlan0: STA 74:f0:6d:33:ea:00 WPA: sending 1/4 msg of 4-Way Handshake
wlan0: STA 74:f0:6d:33:ea:00 WPA: received EAPOL-Key frame (2/4 Pairwise)
wlan0: STA 74:f0:6d:33:ea:00 WPA: sending 3/4 msg of 4-Way Handshake
wlan0: STA 74:f0:6d:33:ea:00 WPA: received EAPOL-Key frame (4/4 Pairwise)
wlan0: STA 74:f0:6d:33:ea:00 IEEE 802.1X: authorizing port
wlan0: STA 74:f0:6d:33:ea:00 RADIUS: starting accounting session
4DB05FB9-00000000
wlan0: STA 74:f0:6d:33:ea:00 WPA: pairwise key handshake completed (RSN)
wlan0: STA 74:f0:6d:33:ea:00 IEEE 802.11: handle_action - unknown
action category 4 or invalid frame
wlan0: STA 74:f0:6d:33:ea:00 MLME:
MLME-DEAUTHENTICATE.indication(74:f0:6d:33:ea:00, 1)
wlan0: STA 74:f0:6d:33:ea:00 MLME: MLME-DELETEKEYS.request(74:f0:6d:33:ea:00)
