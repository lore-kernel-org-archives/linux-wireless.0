Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:52265 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756545Ab1HXInv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 04:43:51 -0400
Received: by vxi9 with SMTP id 9so812191vxi.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Aug 2011 01:43:51 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 24 Aug 2011 16:43:51 +0800
Message-ID: <CAGwCZhqDBZ4QGC_+3Bdbk=vRCnr0=sVdyR3J7WWqExf_hZQpLA@mail.gmail.com> (sfid-20110824_104354_787590_21EB1DB3)
Subject: force wifi radio to sleep immediately
From: Hao Han <hhanwm@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear All,

I am currently working on a research project based on BCM4329 driver
on Nexus One. In the project, I am trying to control wifi radio to sleep
and wake up manually (i.e without setting PM_OFF, PM_FAST, or PM_MAX mode). I
have digged into the source code for a while, but till now I have no
idea how to do that. If possible, could anyone please tell me if there is
any function I can call to force wifi radio to sleep or wake up
immediately.

Any hint is appreciated. Thank you!

Best,
Hao
