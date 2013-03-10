Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:12489 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab3CJGTP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Mar 2013 01:19:15 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
CC: Myoungje Kim <mjei78@gmail.com>, <vthiagar@qca.qualcomm.com>,
	<sumathi@qca.qualcomm.com>,
	ath6kl-devel <ath6kl-devel@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ATH6KL: "Fix the byte alignment rule to avoid loss of bytes in a TCP segment"
References: <CABzs15B0TN=AgF+j9ZZL0yrfXwO31BJktRbXMwcwC5X2ricrkQ@mail.gmail.com>
	<512D9B41.40608@qca.qualcomm.com>
Date: Sun, 10 Mar 2013 08:19:08 +0200
In-Reply-To: <512D9B41.40608@qca.qualcomm.com> (Mohammed Shafi Shajakhan's
	message of "Wed, 27 Feb 2013 11:06:01 +0530")
Message-ID: <871ubnlqub.fsf@kamboji.qca.qualcomm.com> (sfid-20130310_071918_611746_9695EA36)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Steven,

Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com> writes:

> On 02/27/2013 10:47 AM, Myoungje Kim wrote:
>> Hello
>> I am Steven Kim.
>>
>> I found the driver bug which occur loss of some bytes on the TCP/IP stack.
>> Please check this patch and pull-request on github.com.
>> https://github.com/torvalds/linux/pull/27
>
> please cc ath6kl-devel, Linux-wireless and send the patches
> in git-send email. thanks!

I now sent the patch for review. The alignment in ath6kl is a mess, I
wish somebody would fix it properly. But if this patch helps for you,
I'll apply it. At least I don't see any harm from it.

-- 
Kalle Valo
