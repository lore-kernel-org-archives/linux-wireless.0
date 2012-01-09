Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:50539 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996Ab2AINRH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jan 2012 08:17:07 -0500
Received: by werm1 with SMTP id m1so2595867wer.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jan 2012 05:17:06 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 9 Jan 2012 10:17:06 -0300
Message-ID: <CAMAQhePeKnnfQrZHcLcvo=RyuNsp0NgV96PdCyaLxT-X3iWj2A@mail.gmail.com> (sfid-20120109_141724_794241_E15F78AE)
Subject: compat-wireless + libertas + firmware issue
From: Eduardo Silva <edsiper@gmail.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

i have a device with Marvell chip running Kernel 2.6.28. I am looking
to use the updated libertas_sdio driver from compat-wireless. I have
added compat-wireless 2.6.39.1 to the system image and dropped the old
drivers. When using the new libertas_sdio, it cannot find the
firmware:

       libertas: failed to find firmware (-2)

If i build a new system image with the original 2.6.28 libertas
drivers the firmware is located and loaded properly. I also tried
different firmware versions and all have the same behavior. Is there
any difference about how compat-wireless look for specific firmwares
?, i also tried the  CONFIG_FIRMWARE_IN_KERNEL and the issue persist.

any help is appreciated,

regards,

-- 
Eduardo Silva
http://edsiper.linuxchile.cl
http://www.monkey-project.com
