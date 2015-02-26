Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:41225 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923AbbBZPr5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2015 10:47:57 -0500
Received: by wghl18 with SMTP id l18so12058994wgh.8
        for <linux-wireless@vger.kernel.org>; Thu, 26 Feb 2015 07:47:56 -0800 (PST)
Received: from [192.168.0.2] (host179-171-dynamic.56-82-r.retail.telecomitalia.it. [82.56.171.179])
        by mx.google.com with ESMTPSA id n6sm1976736wjy.8.2015.02.26.07.47.55
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Feb 2015 07:47:56 -0800 (PST)
Message-ID: <54EF402E.5020105@gmail.com> (sfid-20150226_164805_471195_B1FCD71D)
Date: Thu, 26 Feb 2015 16:47:58 +0100
From: angelo <angelo70@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: BCM43362, sdio module sn8000
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear all,

was trying to have working a wifi module, sn8000 from muRata,
with a bcm43362 from a imx6q.

I have actually a 3.10 kernel, patched with same patch done on
3.14 for bcm43362, but i have no responses from the sdio module.

Seems sdio probing exits for timeout (110).

Module is correctly powered, and set to sdio 4 wires module.
I am also using devicetree, uhsdc controller is enabled and
should be set up correctly.

Every suggestion is appreciated,

Regards
Angelo
