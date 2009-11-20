Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:51192 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093AbZKTMnB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2009 07:43:01 -0500
Received: by yxe17 with SMTP id 17so2866662yxe.33
        for <linux-wireless@vger.kernel.org>; Fri, 20 Nov 2009 04:43:07 -0800 (PST)
Message-ID: <4B068ED9.5070107@lwfinger.net>
Date: Fri, 20 Nov 2009 06:43:05 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: William Bourque <william.bourque@polymtl.ca>
CC: bcm43xx-dev@lists.berlios.de, Andrew Benton <b3nton@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Fatal DMA error problem with netbook and BCM4312
References: <4AFA09C8.4060602@gmail.com>	<200911131216.43704.mb@bu3sch.de>	<4AFD83CA.2050508@lwfinger.net>	<200911131836.26857.mb@bu3sch.de>	<4AFD9E20.3060501@gmail.com>	<4AFDD1C9.4050402@lwfinger.net>	<4AFDF68C.4040804@polymtl.ca> <4AFE1E5F.9040009@lwfinger.net> <4AFEFC2C.5030704@polymtl.ca>
In-Reply-To: <4AFEFC2C.5030704@polymtl.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

One last check. I would appreciate receiving answers to the following questions.
These questions apply to anyone else with this problem.

Does the pm_qos patch help your "fatal DMA error" problem, particularly when
booted from power-off?

If you warm-boot after loading the wl driver, does the patch make any difference?

Larry
