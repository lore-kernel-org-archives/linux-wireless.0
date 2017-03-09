Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:35590 "EHLO
        mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750940AbdCIEWS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Mar 2017 23:22:18 -0500
Received: by mail-qk0-f170.google.com with SMTP id v125so100093672qkh.2
        for <linux-wireless@vger.kernel.org>; Wed, 08 Mar 2017 20:22:17 -0800 (PST)
MIME-Version: 1.0
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Date: Thu, 9 Mar 2017 12:22:16 +0800
Message-ID: <CAEFj985oo-Dv3dXN7rTTph74mkw_jW=7QrCfEXSjP=OGoexuYg@mail.gmail.com> (sfid-20170309_052221_272239_CB682E78)
Subject: Beacon interval for Mesh/AP in single interface
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Johannes

The introduction of the following patches doesn't allow the AP and
mesh mode to simultaneously run on a single radio interface due to
beacon interval for both interfaces by default is different.
[PATCH] cfg80211: disallow beacon_int_min_gcd with IBSS
[PATCH] cfg80211: support virtual interfaces with different beacon intervals
[PATCH] cfg80211: validate beacon int as part of iface combinations

Any suggestion that we could solve this.

Thanks

---
Chun-Yeow
