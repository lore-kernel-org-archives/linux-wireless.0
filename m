Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11818 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201Ab1GNGqI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 02:46:08 -0400
Message-ID: <4E1E90AB.6030707@qca.qualcomm.com> (sfid-20110714_084612_843535_85C872D7)
Date: Thu, 14 Jul 2011 09:46:03 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: <linux-wireless@vger.kernel.org>, <devel@linuxdriverproject.org>,
	<gregkh@suse.de>
Subject: Re: [PATCH 01/24] ath6kl: add bmi.c
References: <20110713013023.8517.15940.stgit@localhost6.localdomain6>	 <20110713013300.8517.98566.stgit@localhost6.localdomain6>	 <1310531333.1143.25.camel@Joe-Laptop>  <4E1D4479.8090201@qca.qualcomm.com> <1310559554.1662.6.camel@Joe-Laptop>
In-Reply-To: <1310559554.1662.6.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/13/2011 03:19 PM, Joe Perches wrote:
> On Wed, 2011-07-13 at 10:08 +0300, Kalle Valo wrote:
>> On 07/13/2011 07:28 AM, Joe Perches wrote:
>>> This helps grepping the sources for a specific dmesg.
>>> 			ath6kl_err("Unable to decrement the command credit count register: %d\n",
>>> 				   ret);
>> I agree, that would improve readibility. The reason why the lines were
>> split is because of checkpatch warnings. I could unsplit them but then
>> someone else might start complaining about high number checkpatch
>> warnings about long lines. So I really don't know what to do with them.
> 
> Add this patch to checkpatch?
> I'll submit it to Andrew Morton later.

Awesome! I had no idea checkpatch supports this. Just tested this with
ath6kl and I don't get long line warnings with long log messages.

Thank you very much for this!

I see that Andrew already took your patch but anyway:

Tested-by: Kalle Valo <kvalo@qca.qualcomm.comm>

Kalle
