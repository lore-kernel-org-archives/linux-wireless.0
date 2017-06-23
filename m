Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway22.websitewelcome.com ([192.185.46.152]:43805 "EHLO
        gateway22.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753785AbdFWBrl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 21:47:41 -0400
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway22.websitewelcome.com (Postfix) with ESMTP id B150E1796C
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jun 2017 20:25:52 -0500 (CDT)
Date: Thu, 22 Jun 2017 20:25:52 -0500
Message-ID: <20170622202552.Horde.GxVvc-eDjUx8yLnS-c2r82L@gator4166.hostgator.com> (sfid-20170623_034745_630782_EA378BD4)
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] nfc: nci: remove unnecessary null check
References: <28317503-e721-2564-a9ff-82182aa0644a@roeck-us.net>
 <20170613163718.GA5375@embeddedgus>
 <20170622223524.GG21214@zurbaran.ger.intel.com>
In-Reply-To: <20170622223524.GG21214@zurbaran.ger.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Samuel,

Quoting Samuel Ortiz <sameo@linux.intel.com>:

> Hi Gustavo,
>
> On Tue, Jun 13, 2017 at 11:37:18AM -0500, Gustavo A. R. Silva wrote:
>> Remove unnecessary NULL check for pointer conn_info.
>> conn_info is set in list_for_each_entry() using container_of(),
>> which is never NULL.
>>
>> Addresses-Coverity-ID: 1362349
>> Cc: Guenter Roeck <linux@roeck-us.net>
>> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
>> ---
>>  net/nfc/nci/core.c | 9 ++++-----
>>  1 file changed, 4 insertions(+), 5 deletions(-)
> Applied to nfc-next, thanks.
>

Absolutely, glad to help.

Thanks
--
Gustavo A. R. Silva
