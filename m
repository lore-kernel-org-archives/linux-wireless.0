Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f228.google.com ([209.85.218.228]:41891 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbZGPJEi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 05:04:38 -0400
Received: by bwz28 with SMTP id 28so1916113bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2009 02:04:36 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [RFC/RFT 0/5] mac80211: implement background scan
Date: Thu, 16 Jul 2009 11:04:41 +0200
MIME-Version: 1.0
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200907161104.41975.helmut.schaa@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

this patch series implements basic background scanning in mac80211
by interrupting the scan after each scanned channel to allow RX/TX.

I only tested the patches on current wireless-testing with iwlagn
in sw-scan mode and it works fine already. One thing I noticed but
seems to be unrelated is: in sw-scan mode the connection sometimes
stalls and no data is transferred anymore although the connection is
still available and I found no way to recover it without setting
it up again.

So, it would be great if somebody could test the patches on other
hardware as well.

Thanks a lot,
Helmut
