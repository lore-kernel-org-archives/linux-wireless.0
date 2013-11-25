Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2381 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755071Ab3KYQtJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 11:49:09 -0500
Message-ID: <52937F77.9090701@broadcom.com> (sfid-20131125_174915_932779_6AFA3BA0)
Date: Mon, 25 Nov 2013 17:48:55 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>,
	"Luis R. Rodriguez" <mcgrof@kernel.org>
cc: backports@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] backport: need reinit_completion() for kernel
 before v3.13
References: <1385377676-5106-1-git-send-email-arend@broadcom.com>
 <52933600.4020406@hauke-m.de>
In-Reply-To: <52933600.4020406@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/25/2013 12:35 PM, Hauke Mehrtens wrote:
> On 11/25/2013 12:07 PM, Arend van Spriel wrote:
>> The use of INIT_COMPLETION() has been replaced by reinit_completion()
>> in v3.13-rc1. This patch backports that inline function.
>>
>> Cc: <linux-wireless@vger.kernel.org>
>> Signed-off-by: Arend van Spriel <arend@broadcom.com>
>> ---
>>   backport/backport-include/linux/completion.h |   29 ++++++++++++++++++++++++++
>>   1 file changed, 29 insertions(+)
>>   create mode 100644 backport/backport-include/linux/completion.h
>>
>
> This was already added in this commit:
> https://github.com/hauke/backports/commit/d9cb7a967513482c399d44e390429cea3de1d86d
>
> You should use backports for this repository:
> https://github.com/hauke/backports.git

Ok. With my fingers crossed: Did you also solve the whole genl patch 
series that Johannes did in net-next?

Gr. AvS

> Hauke
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


