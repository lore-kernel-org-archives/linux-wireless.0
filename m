Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:35260 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758AbcDCM0t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Apr 2016 08:26:49 -0400
From: poma <pomidorabelisima@gmail.com>
Subject: Re: GDM7240 - NULL pointer dereference
To: Alex <alex3kov@zoho.com>
References: <5700ED33.6020200@zoho.com>
Cc: linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org,
	netdev@vger.kernel.org, Oliver Neukum <oneukum@suse.com>
Message-ID: <57010C05.1050107@gmail.com> (sfid-20160403_142657_073208_BA1D6E06)
Date: Sun, 3 Apr 2016 14:26:45 +0200
MIME-Version: 1.0
In-Reply-To: <5700ED33.6020200@zoho.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03.04.2016 12:15, Alex wrote:
> Hello,
> [1.] System hang when connecting USB modem (LU150)
> [2.] I'm running 4.4.5 kernel (Arch Linux). When this modem is connected 
> I'm getting below trace in journal and system becomes unusable - lsusb, 
> logout and some other operations lead to a complete hang, the only way 
> out is hardware power off. This modem works perfectly on 4.1.20 kernel - 
> attaching all outputs for both kernels.
...

See if it is related to
http://thread.gmane.org/gmane.linux.usb.general/135626

if so, kernel >= 4.5
i.e.
https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/drivers/net/usb/cdc_ether.c?h=linux-4.5.y&id=29c6dd5

