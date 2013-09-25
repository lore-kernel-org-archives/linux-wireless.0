Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f52.google.com ([209.85.212.52]:61102 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755648Ab3IYBlA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Sep 2013 21:41:00 -0400
Received: by mail-vb0-f52.google.com with SMTP id f12so3836979vbg.39
        for <linux-wireless@vger.kernel.org>; Tue, 24 Sep 2013 18:40:59 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 25 Sep 2013 07:10:59 +0530
Message-ID: <CACPKTAP_rc2FmzjP2qtO0+rWtK9Wk_WyRtngrtM3FnZQF9JHyA@mail.gmail.com> (sfid-20130925_034108_701054_2D1EA7F5)
Subject: Tracing Association code
From: Prabhunath G <gprabhunath@gmail.com>
To: kernelnewbies <kernelnewbies@kernelnewbies.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

         I am tracing the association code in linux-wireless. I
understand that association request has to be triggered from station
side (userspace-wpa_supplicant) and has to be sent to the AP
(userspace-hostapd).

In the process of tracing, I found the function ieee80211_assoc(...)
in net/mac80211/cfg.c and also I found that a timer is scheduled to
execute the timer function. My Questions are

1. Who is initiating the timer function, my guess is it should be the
driver & How ?
2. On the AP side how is the association request taken from driver  ->
mac80211 -> hostapd.

Appreciate your help.

Thanks,
Prabhu
