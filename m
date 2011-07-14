Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24405 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747Ab1GNHiX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 03:38:23 -0400
Message-ID: <4E1E9CE7.2070305@qca.qualcomm.com> (sfid-20110714_093827_194615_12F903FD)
Date: Thu, 14 Jul 2011 10:38:15 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: <linux-wireless@vger.kernel.org>, <devel@linuxdriverproject.org>,
	<gregkh@suse.de>
Subject: Re: [PATCH 01/24] ath6kl: add bmi.c
References: <20110713013023.8517.15940.stgit@localhost6.localdomain6>	 <20110713013300.8517.98566.stgit@localhost6.localdomain6>	 <1310531333.1143.25.camel@Joe-Laptop>  <4E1D4479.8090201@qca.qualcomm.com>	 <1310559554.1662.6.camel@Joe-Laptop>  <4E1E90AB.6030707@qca.qualcomm.com> <1310628837.7582.12.camel@Joe-Laptop>
In-Reply-To: <1310628837.7582.12.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/14/2011 10:33 AM, Joe Perches wrote:
> On Thu, 2011-07-14 at 09:46 +0300, Kalle Valo wrote:
>> On 07/13/2011 03:19 PM, Joe Perches wrote:
>>> Add this patch to checkpatch?
>>> I'll submit it to Andrew Morton later.
>> Awesome! I had no idea checkpatch supports this. Just tested this with
>> ath6kl and I don't get long line warnings with long log messages.
> 
> Note that this doesn't let you have arbitrarily
> long lines just because it's a printk or any other
> logging function.  Only the format portion of the
> printk may exceed 80 columns.
> 
> Any additional arguments for the printk must not
> start after or exceed 80 columns.

Thanks, that's good to know. And it's a very nice feature. I also hate
long lines but splitting log messages doesn't really make any sense.

Kalle
