Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:63517 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab2LKFa0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 00:30:26 -0500
Message-ID: <50C6C4D1.6070607@gmail.com> (sfid-20121211_063052_515386_4391A77F)
Date: Tue, 11 Dec 2012 10:59:53 +0530
From: Abhijit Pawar <abhi.c.pawar@gmail.com>
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: abhi.c.pawar@gmail.com, pablo@netfilter.org, kaber@trash.net,
	kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
	linville@tuxdriver.com, johannes@sipsolutions.net,
	amwang@redhat.com, edumazet@google.com, nhorman@tuxdriver.com,
	joe@perches.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
	netfilter@vger.kernel.org, coreteam@netfilter.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH RESEND RESEND] net: remove obsolete simple_strto<foo>
References: <1355196860-10708-1-git-send-email-abhi.c.pawar@gmail.com> <20121210.234923.94776338088489257.davem@davemloft.net>
In-Reply-To: <20121210.234923.94776338088489257.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/11/2012 10:19 AM, David Miller wrote:
> From: Abhijit Pawar <abhi.c.pawar@gmail.com>
> Date: Tue, 11 Dec 2012 09:04:20 +0530
> 
>> This patch replace the obsolete simple_strto<foo> with kstrto<foo>
>>
>> Signed-off-by: Abhijit Pawar <abhi.c.pawar@gmail.com>
> 
> You can't submit replacement patches for ones which I have already
> applied.
> 
> Patches I apply are permanently applied, and therefore you must submit
> changes relative the ones I've applied already.
> 
I am sorry to create this confusion. I have created and sent the new
patch which you can apply over the old one to fix the issues.

-- 
-
Abhijit
