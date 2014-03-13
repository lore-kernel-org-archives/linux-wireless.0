Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:37430 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbaCMFFS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Mar 2014 01:05:18 -0400
Received: by mail-pb0-f47.google.com with SMTP id up15so562673pbc.6
        for <linux-wireless@vger.kernel.org>; Wed, 12 Mar 2014 22:05:17 -0700 (PDT)
MIME-Version: 1.0
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Wed, 12 Mar 2014 22:04:37 -0700
Message-ID: <CAGVrzcaWBAo3kiQ5jLKv_XMyuUL-pf1Vj2kL8E8YVnLrm4Mj7A@mail.gmail.com> (sfid-20140313_060522_861556_691DF65A)
Subject: skb->priority magic values as part of UAPI headers?
To: "open list:ATHEROS ATH5K WIR..." <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

While browsing through net/wireless/util.c::cfg80211_classify8021d() I
stumbled upon the "magic values" range 256 to 263, should not those be
made part of some sort of user-space API header file, just so if
things need to be changed, they suddenly do not break?

Thanks
-- 
Florian
