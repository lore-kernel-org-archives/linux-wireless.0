Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46861 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab0ENAV1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 20:21:27 -0400
Message-ID: <4BEC9782.2040705@gmail.com>
Date: Thu, 13 May 2010 17:21:22 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: linux-wireless@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ath9k: BUG kmalloc-8192: Poison overwritten
References: <4BEC7A84.3010503@gmail.com> <AANLkTim7B5z76zJ33by6SGMgSy1gZF6qiwhEhAQ3NUtG@mail.gmail.com>
In-Reply-To: <AANLkTim7B5z76zJ33by6SGMgSy1gZF6qiwhEhAQ3NUtG@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/13/10 16:01, Luis R. Rodriguez wrote:
> On Thu, May 13, 2010 at 3:17 PM, Justin P. Mattock
> <justinmattock@gmail.com>  wrote:
>> not sure what this is, but while at a convention
>> I was trying to access the internet and(below is
>> full dmesg) this showed up.
>>
>> After receiving this, I sat and tried to re-create
>> my steps to reproduce but had no luck(was even going
>> todo a bisect n the spot if I could re-create).
>
> OK this stuff is hard to reproduce it seems.. you have an Atheros
> AR5418 MAC/BB Rev:2 AR5133 RF Rev:81, what kconfig option do you use
> to get the poison stuff? I am just surprised we haven't seen it
> ourselves yet. Let me make sure all of us get this kconfig option
> enabled.
>
>    Luis
>



CONFIG_ATH_COMMON=m
# CONFIG_ATH_DEBUG is not set
CONFIG_ATH5K=m
# CONFIG_ATH5K_DEBUG is not set
CONFIG_ATH9K_HW=m
CONFIG_ATH9K_COMMON=m
CONFIG_ATH9K=m
# CONFIG_ATH9K_DEBUGFS is not set

if you need my .config let me know.
(I can try again reproducing, but man
just doesn't easily fire off).

Justin P. Mattock
