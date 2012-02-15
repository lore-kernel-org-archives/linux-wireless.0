Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:41229 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751903Ab2BOKoC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Feb 2012 05:44:02 -0500
Received: by mail-lpp01m010-f46.google.com with SMTP id u2so1133055lag.33
        for <linux-wireless@vger.kernel.org>; Wed, 15 Feb 2012 02:44:01 -0800 (PST)
Message-ID: <1329302638.19569.51.camel@cumari> (sfid-20120215_114407_409329_E739CC11)
Subject: Re: [PATCH 0/3] wl12xx: re-enable auto-arp
From: Luciano Coelho <coelho@ti.com>
To: Fu yingang <yingang.fu@borqs.com>
Cc: Eliad Peller <eliad@wizery.com>, linux-wireless@vger.kernel.org
Date: Wed, 15 Feb 2012 12:43:58 +0200
In-Reply-To: <EB4DA10182044DDE952EF2C4B81CF6B3@7CF9T2X>
References: <1328178131-28938-1-git-send-email-eliad@wizery.com>
	 <1329301121.19569.43.camel@cumari>
	 <EB4DA10182044DDE952EF2C4B81CF6B3@7CF9T2X>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-02-15 at 18:41 +0800, Fu yingang wrote: 
> hi, all

Hi Yingang.


> Where can i find the latest code?

You can find it here:

git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git

This is the official integration tree for wl12xx code (use the master
branch, which is based on the latest wireless-testing).

I'll send a pull request today, so this stuff will probably go into
wireless-testing very soon.

-- 
Cheers,
Luca.

