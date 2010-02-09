Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f202.google.com ([209.85.216.202]:40437 "EHLO
	mail-px0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250Ab0BIOiJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Feb 2010 09:38:09 -0500
Received: by pxi40 with SMTP id 40so7376602pxi.21
        for <linux-wireless@vger.kernel.org>; Tue, 09 Feb 2010 06:38:09 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 9 Feb 2010 20:01:55 +0530
Message-ID: <74ccb2ee1002090631i4a29d320u2756af13de05cb97@mail.gmail.com>
Subject: CFG80211 depends on RFKILL or not
From: Jaswinder Singh Rajput <jaswindernetwork@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

>From :
http://git.kernel.org/?p=linux/kernel/git/linville/wireless-2.6.git;a=blob;f=net/wireless/Kconfig;h=90e93a5701aacdd933384419d591e2e72d936d6b;hb=HEAD

I am trying to understand what is the magic behind :

19 config CFG80211
20         tristate "cfg80211 - wireless configuration API"
21         depends on RFKILL || !RFKILL

Do we really need RFKILL and !RFKILL

Thanks,
--
JSR
