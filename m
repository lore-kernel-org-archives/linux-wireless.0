Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sender153-mail.zoho.com ([74.201.84.153]:21760 "EHLO
	sender153-mail.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952AbcDCQUM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Apr 2016 12:20:12 -0400
Subject: Re: GDM7240 - NULL pointer dereference
To: poma <pomidorabelisima@gmail.com>
References: <5700ED33.6020200@zoho.com> <57010C05.1050107@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org,
	netdev@vger.kernel.org, Oliver Neukum <oneukum@suse.com>
From: Alex <alex3kov@zoho.com>
Message-ID: <570142B5.9060800@zoho.com> (sfid-20160403_182019_672747_3F131B61)
Date: Sun, 3 Apr 2016 19:20:05 +0300
MIME-Version: 1.0
In-Reply-To: <57010C05.1050107@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks, looks like exactly the same issue, I'll check if it works on 4.5.

/--Regards, Alex/

On 03/04/16 15:26, poma wrote:
> On 03.04.2016 12:15, Alex wrote:
>> Hello,
>> [1.] System hang when connecting USB modem (LU150)
>> [2.] I'm running 4.4.5 kernel (Arch Linux). When this modem is connected
>> I'm getting below trace in journal and system becomes unusable - lsusb,
>> logout and some other operations lead to a complete hang, the only way
>> out is hardware power off. This modem works perfectly on 4.1.20 kernel -
>> attaching all outputs for both kernels.
> ...
>
> See if it is related to
> http://thread.gmane.org/gmane.linux.usb.general/135626
>
> if so, kernel >= 4.5
> i.e.
> https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/drivers/net/usb/cdc_ether.c?h=linux-4.5.y&id=29c6dd5
>

