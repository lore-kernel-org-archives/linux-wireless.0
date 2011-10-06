Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:48227 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757226Ab1JFUa6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Oct 2011 16:30:58 -0400
Received: by mail-bw0-f42.google.com with SMTP id r4so8098434bka.1
        for <linux-wireless@vger.kernel.org>; Thu, 06 Oct 2011 13:30:56 -0700 (PDT)
Subject: wl12xx: tired of the sdio_test module
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 Oct 2011 23:30:53 +0300
Message-ID: <1317933053.3549.66.camel@cumari> (sfid-20111006_223101_897576_FF6B334A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Again, I've made some changes in the main wl12xx modules and the
sdio_test module broke.  Now I'm getting tired of it.  Whenever we make
changes in the main modules, we need to change it accordingly.  My
current changes in the way the bus modules work, has broken it
completely and I don't want to spend too much time fixing it.

So there are two options:

1) remove the sdio_test module completely;
2) copy the header files it uses so that changes in the real headers
won't break it;

I'll send one patch for each option and, tomorrow when I continue my
integration round, depending on my mood, I'll choose one to apply. :)

Maybe if I do 2) the driver should be moved to staging? ;)

-- 
Cheers,
Luca.

