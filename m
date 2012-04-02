Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60008 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab2DBSEN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Apr 2012 14:04:13 -0400
Received: by obbtb18 with SMTP id tb18so2376883obb.19
        for <linux-wireless@vger.kernel.org>; Mon, 02 Apr 2012 11:04:13 -0700 (PDT)
Message-ID: <4F79EA18.9060502@lwfinger.net> (sfid-20120402_200417_563805_5DF9ADE4)
Date: Mon, 02 Apr 2012 13:04:08 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Forest Bond <forest@alittletooquiet.net>
CC: linux-wireless@vger.kernel.org,
	Chaoming Li <chaoming_li@realsil.com.cn>
Subject: Re: [PATCH 1/2] rtl8192de: Clean up and fix 92D cut version constants
 and macros.
References: <20120402142525.GA20611@alittletooquiet.net> <4F79E7B9.7060504@lwfinger.net> <20120402175745.GE20611@alittletooquiet.net>
In-Reply-To: <20120402175745.GE20611@alittletooquiet.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/02/2012 12:57 PM, Forest Bond wrote:
> Hi Larry,
>
> On Mon, Apr 02, 2012 at 12:54:01PM -0500, Larry Finger wrote:
>> On 04/02/2012 09:25 AM, Forest Bond wrote:
>>> From: Forest Bond<forest.bond@rapidrollout.com>
>>>
>>> The previous definitions included both {B,C,D,E}_CUT_VERSION and
>>> CHIP_92D_{C,D}_CUT with conflicting values for the C and D cut versions,
>>> and literal hex values were used in the IS_92D_{C,D,E}_CUT macros.  So
>>> we clean all this up and in doing so enable cut-specific code paths for
>>> cuts C and D, which would not have been executed because the
>>> CHIP_92D_{C,D}_CUT constants were wrong and the cut version was thus
>>> recorded incorrectly.
>>>
>>> Signed-off-by: Forest Bond<forest.bond@rapidrollout.com>
>>
>> This patch does not apply to the wireless-testing tree. That is the
>> one you are supposed to use.
>>
>> Patch #2 also fails to apply. In addition, your mailer mangled a line.
>
> Sorry for the trouble.  I'll resend a little later this afternoon.

No problem for me. I was able to fix everything but the mangling with wiggle.

Larry

