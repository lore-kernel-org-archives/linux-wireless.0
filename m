Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:60678 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab2DEMfV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Apr 2012 08:35:21 -0400
Received: by qcro28 with SMTP id o28so800108qcr.19
        for <linux-wireless@vger.kernel.org>; Thu, 05 Apr 2012 05:35:20 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 5 Apr 2012 14:35:20 +0200
Message-ID: <CAFED-jmkmF=9egOvvRK49=2HYMg_jiAUdW=5XQ2SyFwYXDb1OQ@mail.gmail.com> (sfid-20120405_143524_201944_133524A9)
Subject: compat-wireless-2012-04-04 - rmmod mac80211 and PC freeze
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
To: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I am using: compat-wireless-2012-04-04

I am doing such test:
- insmod compat.ko
- insmod cfg80211.ko
- insmod mac80211.ko

After that:
- rmmod mac80211

And have PC freeze.
Linux uw000950 2.6.35-32-generic #67~lucid1-Ubuntu SMP Tue Mar 6
17:48:20 UTC 2012 x86_64 GNU/Linux

Any idea what could be wrong, how to debug in case of such freeze?

BR
Janusz
