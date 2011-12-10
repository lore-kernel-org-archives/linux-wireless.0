Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60295 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab1LJEiL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Dec 2011 23:38:11 -0500
Received: by wgbdr13 with SMTP id dr13so6979746wgb.1
        for <linux-wireless@vger.kernel.org>; Fri, 09 Dec 2011 20:38:09 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 9 Dec 2011 23:38:09 -0500
Message-ID: <CALGY4fvRCRwqvncw8nqkEN-mGB5syHXbWKpRspbxC=6Fccpa1g@mail.gmail.com> (sfid-20111210_053827_101238_CDEB7603)
Subject: Spontaneous disconnections debugging
From: Nikolay Martynov <mar.kolya@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi.

  I have an intel 5300 as client and openwrt ath9k based router as AP.
Some times (once in several days) I get wireless connection
spontaneously dropped with this message on client:
 wlan1: deauthenticating from XX:XX:XX:XX:XX:XX by local choice (reason=3)

  Not that this really creates problems for me, connection is quickly
restored and otherwise works fine.

  So my question is - what would be the best approach to debug this
problem? I would appreciate any ideas where I could start.
  Thanks!

-- 
Truthfully yours,
Martynov Nikolay.
Email: mar.kolya@gmail.com
