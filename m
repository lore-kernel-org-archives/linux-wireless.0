Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f41.google.com ([209.85.214.41]:48246 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383Ab3BEVnw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2013 16:43:52 -0500
Received: by mail-bk0-f41.google.com with SMTP id q16so330738bkw.14
        for <linux-wireless@vger.kernel.org>; Tue, 05 Feb 2013 13:43:50 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Tomasz Guszkowski <tsg@o2.pl>
Subject: Re: [PATCH] p54usb: corrected USB ID for T-Com Sinus 154 data II
Date: Tue, 5 Feb 2013 22:43:43 +0100
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <20130205221031.05608bc50352b172003ec69e@o2.pl>
In-Reply-To: <20130205221031.05608bc50352b172003ec69e@o2.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201302052243.43567.chunkeey@googlemail.com> (sfid-20130205_224355_998482_4F678E36)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Added John [He takes all the driver patches ;).

John, do you want/need a line-wrapped commit message
of the original patch or is this OK?) 

On Tuesday, February 05, 2013 10:10:31 PM Tomasz Guszkowski wrote:
> Corrected USB ID for T-Com Sinus 154 data II. ISL3887-based.
> The device was tested in managed mode with no security, WEP
> 128 bit and WPA-PSK (TKIP) with firmware 2.13.1.0.lm87.arm
> (md5sum: 7d676323ac60d6e1a3b6d61e8c528248). It works.
> 
> Signed-off-by: Tomasz Guszkowski <tsg@o2.pl>
Cc: <stable@vger.kernel.org>
Acked-By: Christian Lamparter <chunkeey@googlemail.com>
> ---

I'll take care of updating the wireless.kernel.org wiki
<http://wireless.kernel.org/en/users/Drivers/p54/devices>
entry later this week.
 
OT: The latest supported firmware for LM87 is: 2.13.25.0.lm87.arm
Did you experience issues with the new version, or do you simply
stick with the old 2.13.1.0 because it does work just as well?

Regards

Christian
