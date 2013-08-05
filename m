Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f54.google.com ([209.85.219.54]:48973 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121Ab3HEQu5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Aug 2013 12:50:57 -0400
Received: by mail-oa0-f54.google.com with SMTP id o6so6869230oag.27
        for <linux-wireless@vger.kernel.org>; Mon, 05 Aug 2013 09:50:55 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 5 Aug 2013 19:50:55 +0300
Message-ID: <CAMqXVCL7dns1VA49Y5qjX4sSPSDYp-SP-ucSk+9UAGTkutiEkA@mail.gmail.com> (sfid-20130805_185106_635987_A6547C6A)
Subject: Using nl80211.h to scan access points
From: Ari Malinen <ari.malinen@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Im trying to use nl80211.h for scanning access points for simple wlan
manager. I cant find any example code and only documentation i can
find is kerneldoc. I have been trying to study from iw and
wpa_supplicant source but its rather complex.

This is only documentation i can find:
NL80211_CMD_GET_SCAN get scan results
NL80211_CMD_TRIGGER_SCAN trigger a new scan with the given parameters
NL80211_ATTR_TX_NO_CCK_RATE is used to decide whether to send the
probe requests at CCK rate or not.

How can i scan access points with nl80211? I think i need to use enum
nl80211_commands {NL80211_CMD_GET_SCAN NL80211_CMD_TRIGGER_SCAN}. How
can i use them?
