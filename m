Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:52765 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754591Ab3KYQwd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 11:52:33 -0500
Message-ID: <52938049.5070701@hauke-m.de> (sfid-20131125_175236_762393_CCE8A678)
Date: Mon, 25 Nov 2013 17:52:25 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>,
	"Luis R. Rodriguez" <mcgrof@kernel.org>
CC: backports@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] backport: need reinit_completion() for kernel before
 v3.13
References: <1385377676-5106-1-git-send-email-arend@broadcom.com> <52933600.4020406@hauke-m.de> <52937F77.9090701@broadcom.com>
In-Reply-To: <52937F77.9090701@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/25/2013 05:48 PM, Arend van Spriel wrote:
> On 11/25/2013 12:35 PM, Hauke Mehrtens wrote:
>> On 11/25/2013 12:07 PM, Arend van Spriel wrote:
>>> The use of INIT_COMPLETION() has been replaced by reinit_completion()
>>> in v3.13-rc1. This patch backports that inline function.
>>>
>>> Cc: <linux-wireless@vger.kernel.org>
>>> Signed-off-by: Arend van Spriel <arend@broadcom.com>
>>> ---
>>>   backport/backport-include/linux/completion.h |   29
>>> ++++++++++++++++++++++++++
>>>   1 file changed, 29 insertions(+)
>>>   create mode 100644 backport/backport-include/linux/completion.h
>>>
>>
>> This was already added in this commit:
>> https://github.com/hauke/backports/commit/d9cb7a967513482c399d44e390429cea3de1d86d
>>
>>
>> You should use backports for this repository:
>> https://github.com/hauke/backports.git
> 
> Ok. With my fingers crossed: Did you also solve the whole genl patch
> series that Johannes did in net-next?
> 
> Gr. AvS

Yes, Johannes solved that already. It works with current linux-next and
3.13-rc1.

Hauke
