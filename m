Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:38302 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751295AbeBTNqY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Feb 2018 08:46:24 -0500
Received: by mail-wr0-f195.google.com with SMTP id n7so14548931wrn.5
        for <linux-wireless@vger.kernel.org>; Tue, 20 Feb 2018 05:46:24 -0800 (PST)
From: Carlo Caione <carlo@caione.org>
To: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        frederic.danis.oss@gmail.com, sebastian.reichel@collabora.co.uk,
        rafael.j.wysocki@intel.com, hdegoede@redhat.com, linux@endlessm.com
Cc: Carlo Caione <carlo@endlessm.com>
Subject: [RFC PATCH 0/2] net: rfkill: gpio: Fix and support SerDev
Date: Tue, 20 Feb 2018 13:46:16 +0000
Message-Id: <20180220134618.12972-1-carlo@caione.org> (sfid-20180220_144629_721285_C09046E9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Carlo Caione <carlo@endlessm.com>

Hi,
this patch came after investigating why the rfkill-gpio driver was failing on
the latest kernel on a machine I have. Sending this out as RFC because I'm
still not sure if this is the right way to approach this problem. I was
honestly expecting not to see the platform devices failing as consequences of
the latest work on SerDev.

Carlo Caione (2):
  net: rfkill: gpio: Fix NULL pointer deference
  net: rfkill: gpio: Convert driver to SerDev

 net/rfkill/Kconfig       |  1 +
 net/rfkill/rfkill-gpio.c | 48 +++++++++++++++++++++++++-----------------------
 2 files changed, 26 insertions(+), 23 deletions(-)

-- 
2.14.1
