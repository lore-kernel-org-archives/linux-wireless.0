Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:60187 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934AbaEPErZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2014 00:47:25 -0400
Received: by mail-pb0-f47.google.com with SMTP id rp16so2053874pbb.34
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2014 21:47:24 -0700 (PDT)
Date: Fri, 16 May 2014 12:47:21 +0800
From: Adam Lee <adam.lee@canonical.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: netdev@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Realtek RTL8723BE drops connection with MSI enabled on some systems
Message-ID: <20140516044721.GA3201@adam-laptop> (sfid-20140516_064729_388860_C32AF4CA)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Larry

For your and others' information, Realtek RTL8723BE drops connection
with MSI enabled on some certion systems too, you may wanna take a look
at the bug[1].

Luckily, in wireless-next, I already set RTL8723BE and RTL8188EE's MSI
to false by default.

https://bugs.launchpad.net/bugs/1320070

-- 
Adam Lee
