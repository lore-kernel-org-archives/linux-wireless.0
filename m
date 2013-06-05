Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:39830 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640Ab3FELJu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 07:09:50 -0400
From: Kalle Valo <kvalo@adurom.com>
To: "Arend van Spriel" <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"David Miller" <davem@davemloft.net>
Subject: Re: [PATCH] brcmsmac: disable power-save related functions
References: <1370419185-3977-1-git-send-email-arend@broadcom.com>
	<878v2p3qst.fsf@purkki.adurom.net> <874ndd3q20.fsf@purkki.adurom.net>
	<51AEFACD.7000902@broadcom.com>
Date: Wed, 05 Jun 2013 14:09:47 +0300
In-Reply-To: <51AEFACD.7000902@broadcom.com> (Arend van Spriel's message of
	"Wed, 5 Jun 2013 10:46:05 +0200")
Message-ID: <87zjv43jb8.fsf@purkki.adurom.net> (sfid-20130605_130953_730031_F3750563)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Arend van Spriel" <arend@broadcom.com> writes:

> On 06/05/2013 10:44 AM, Kalle Valo wrote:
>> Kalle Valo <kvalo@adurom.com> writes:
>>
>>> "Arend van Spriel" <arend@broadcom.com> writes:
>>>
>>>> This patch fixes a regression introduced by:
>>>>
>>>>    commit 6da3b6c48d79da96a36c2632053cf4f53bf48fb2
>>>>    Author: Hauke Mehrtens <hauke@hauke-m.de>
>>>>    Date:   Sun Mar 24 01:45:52 2013 +0100
>>>>
>>>>        brcmsmac: remove brcms_bss_cfg->associated
>>>>
>>>> The regression behaviour is described in:
>>>>
>>>> http://www.spinics.net/lists/linux-wireless/msg107474.html
>>>
>>> The link is not a very reliable reference, it can die anytime and
>>> there's no way to know what message it refers to. Stating the message id
>>> would better. And the best would be to copy the full text to the commit
>>> log, it's only few lines anyway.
>>
>> Johannes gave a handy tip. Gmane has a service which uses message ids:
>>
>> http://mid.gmane.org/5197DC4F.7030503@broadcom.com
>>
>> If the link or service dies, one can find the email with the message id
>> visible from the link.
>>
>
> What if gmane dies ;-)

You missed my point. If gmane dies you do this:

http://lmgtfy.com/?q=5197DC4F.7030503%40broadcom.com

:D

The id above is the real message id from the email, that's why you can
use it to search from email archives, google and so on.

-- 
Kalle Valo
