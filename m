Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41531 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab1HLBOn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 21:14:43 -0400
Received: by eyx24 with SMTP id 24so1734465eyx.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Aug 2011 18:14:42 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 11 Aug 2011 20:14:42 -0500
Message-ID: <CAMB9Wx+ei1SkoABuOyPJ0LnS1tgJbNXRcQ7L6yTYqpRWgCcx1A@mail.gmail.com> (sfid-20110812_031447_319471_32CDA936)
Subject: Power saving in AP mode
From: Harsha Chenji <cjkernel@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,

Trying to get an ath9k based AP to do some power saving on a client. A
power saving STA (windows/broadcom) which can normally do PS when
connected to other networks, fails to do so on this one (verified by
measuring current on a scope).

Could anyone please help me? Is AP side PSM supported in ath9k? All
this is being done on openwrt/2.6.36.2, with somewhat recent
iw/wireless-tools/hostapd. compat-wireless-2010-12-09 is being used.

Thanks a lot
