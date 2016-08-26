Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:33927 "EHLO
        mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752031AbcHZVyg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Aug 2016 17:54:36 -0400
Received: by mail-lf0-f43.google.com with SMTP id l89so65517562lfi.1
        for <linux-wireless@vger.kernel.org>; Fri, 26 Aug 2016 14:54:08 -0700 (PDT)
MIME-Version: 1.0
From: Ramon Fontes <ramonreisfontes@gmail.com>
Date: Fri, 26 Aug 2016 23:53:46 +0200
Message-ID: <CAK8U23YMkeYTQb2HNuqG9xfeKkv50X0MKE5r7vY=-icExF7xWA@mail.gmail.com> (sfid-20160826_235440_788454_BCC5ED09)
Subject: mac80211_hwsim: handling RSSI
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am developing a wireless network emulator
(https://github.com/intrig-unicamp/mininet-wifi) and I was wondering
what is the best way to change the RSSI information provided by
mac80211_hwsim. I am able to calculate the RSSI with my emulator, but
the RSSI is not updated by mac80211_hwsim, of course. Do I have to
make changes in nl80211?

Thank you in advance,
Ramon Fontes
