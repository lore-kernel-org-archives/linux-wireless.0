Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36109 "EHLO
	mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbcF0BtE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jun 2016 21:49:04 -0400
Subject: Re: [PATCH] rtlwifi: Add missing newlines to RT_TRACE calls
To: Joe Perches <joe@perches.com>,
	Chaoming Li <chaoming_li@realsil.com.cn>
References: <5677791872bfb47963780c198c825d882456720f.1466969647.git.joe@perches.com>
 <577070D9.5080503@lwfinger.net> <1466990029.1847.74.camel@perches.com>
 <1466990779.1847.78.camel@perches.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <5770860D.8040607@lwfinger.net> (sfid-20160627_034928_114710_66BD5942)
Date: Sun, 26 Jun 2016 20:49:01 -0500
MIME-Version: 1.0
In-Reply-To: <1466990779.1847.78.camel@perches.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/26/2016 08:26 PM, Joe Perches wrote:
> On Sun, 2016-06-26 at 18:13 -0700, Joe Perches wrote:
>> On Sun, 2016-06-26 at 19:18 -0500, Larry Finger wrote:
>>>
>>> On 06/26/2016 02:34 PM, Joe Perches wrote:
>>>>
>>>>
>>>> RT_TRACE does not add a newline to the end of a message and always
>>>> emits at KERN_DEBUG so these are susceptible to message
>>>> interleaving
>>>> from other processes without the newline.
>>>>
>>>> Signed-off-by: Joe Perches <joe@perches.com>
>>>> ---
>>> This patch does not apply to the wireless-drivers-next repo. Which
>>> one
>>> did you use?
>> linux-next
>
> btw: both patches seem to apply to wireless-drivers-next just fine.
>
> $ git rev-parse HEAD
> 1bb57c8a5e33bcbec031ce0c629968922d5af89d
> $ git am ../next/0001-rtlwifi-Create-_rtl_dbg_trace-function-to-reduce-RT_.patch
> Applying: rtlwifi: Create _rtl_dbg_trace function to reduce RT_TRACE code size
> $ git am ../next/0001-rtlwifi-Add-missing-newlines-to-RT_TRACE-calls.patch
> Applying: rtlwifi: Add missing newlines to RT_TRACE calls

The conflict is with the set of 10 patches I sent out yesterday. As I have to 
update them anyway, I will apply yours first, then do mine. That should resolve 
the problem.

Larry




