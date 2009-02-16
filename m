Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:38683 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751339AbZBPXSR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2009 18:18:17 -0500
Message-ID: <4999F427.4060008@lwfinger.net> (sfid-20090217_001820_808815_35CEE6E8)
Date: Mon, 16 Feb 2009 17:17:59 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	viktor.ilijasic@gmail.com
Subject: Re: rtl8187 not handling my usb card
References: <4999F3A6.7020208@gmail.com>
In-Reply-To: <4999F3A6.7020208@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Xose Vazquez Perez wrote:
> John W. Linville wrote:
> 
>> You might try applying the patch below and rebuilding your kernel.
> 
> easier, try:
> 
> # modprobe rtl8187
> # echo "0x1b75 0x8187" > /sys/bus/usb/drivers/rtl8187/new_id

When you do that, does it work?

Larry
