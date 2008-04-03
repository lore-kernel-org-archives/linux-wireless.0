Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from n12c.bullet.scd.yahoo.com ([66.218.67.49]:26394 "HELO
	n12c.bullet.scd.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755054AbYDCRsM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 13:48:12 -0400
Message-ID: <47F5144C.6000800@yahoo.it> (sfid-20080403_184819_052657_3FC668BF)
Date: Thu, 03 Apr 2008 19:30:52 +0200
From: Filippo Zangheri <filippo.zangheri@yahoo.it>
MIME-Version: 1.0
To: "Chatre, Reinette" <reinette.chatre@intel.com>
CC: ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: add missing include in iwl-3945-led.c
References: <47F4AFE8.4020405@yahoo.it> <D936D925018D154694D8A362EEB089200419511C@orsmsx416.amr.corp.intel.com>
In-Reply-To: <D936D925018D154694D8A362EEB089200419511C@orsmsx416.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chatre, Reinette ha scritto:
> On Thursday, April 03, 2008 3:23 AM, Filippo Zangheri  wrote:
> 
>> iwl-3945-led.c does not include a relevant file.
>>
>> Signed-off-by: Filippo Zangheri <filippo.zangheri@yahoo.it> ---
>> drivers/net/wireless/iwlwifi/iwl-3945-led.c |    1 +
>> 1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-led.c
>> b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
>> index d200d08..7743cac 100644
>> --- a/drivers/net/wireless/iwlwifi/iwl-3945-led.c
>> +++ b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
>> @@ -40,6 +40,7 @@
>> #include <asm/unaligned.h>
>>
>> #include "iwl-3945.h"
>> +#include "iwl-3945-led.h"
>> #include "iwl-helpers.h"
>>
>> #define IWL_1MB_RATE (128 * 1024)
>>
> 
> ... but iwl-3945.h which is just above the line you added already
> includes this header file.

Right, but here it refused to compile without this.. I apologize,
I'm really sorry!

-- 
Filippo Zangheri

GPG key ID: 0xE1D879FA
Key fingerprint: 816B CE57 D43C 0A47 EF35 3378 EA5F A72A E1D8 79FA
Key server: pgp.mit.edu

-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GE d- s+:- a-- C++ UL+++ P+ L+++ E-- W+ N* o-- K- w--- O-- M--
V- PS++ PE+ Y+ PGP++ t 5-- X++ R* tv b+ DI-- D---- G-- e++ h--
r++ z*
------END GEEK CODE BLOCK------

