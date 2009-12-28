Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:38722 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbZL1WAf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Dec 2009 17:00:35 -0500
Subject: Re: staging: No option to select rtl8192su in linux-2.6.33-rc2
From: Marcel Holtmann <marcel@holtmann.org>
To: Chris Mayo <aklhfex@googlemail.com>
Cc: linux-wireless@vger.kernel.org, Greg KH <greg@kroah.com>
In-Reply-To: <4B38A298.7070103@googlemail.com>
References: <4B38A298.7070103@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Dec 2009 13:59:50 -0800
Message-ID: <1262037590.16627.99.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Chris,

> If you have no other wireless drivers selected then RealTek RTL8192SU
> does not show up in menuconfig for staging.
> 
> rtl8192su needs the "select WIRELESS_EXT" fix for "wext: refactor"?
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=3d23e349d807177eaf519d444677cee86b1a04cf
> 
> as done for some in:
> http://git.kernel.org/?p=linux/kernel/git/gregkh/staging-2.6.git;a=commitdiff;h=125b181aec7a67c71234284ecf6d9c729d05deda
> 
> 
> Also:
> rtl8192u, wlan-ng, wlags49_h2(?)

if staging drivers break, then please create a patch and mail it do
Greg. Don't bother linux-wireless with it since nobody here actually
cares about the staging drivers.

Regards

Marcel


