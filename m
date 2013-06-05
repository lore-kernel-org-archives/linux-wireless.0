Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2300 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949Ab3FEIqc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 04:46:32 -0400
Message-ID: <51AEFACD.7000902@broadcom.com> (sfid-20130605_104636_904551_C6297722)
Date: Wed, 5 Jun 2013 10:46:05 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Kalle Valo" <kvalo@adurom.com>
cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"David Miller" <davem@davemloft.net>
Subject: Re: [PATCH] brcmsmac: disable power-save related functions
References: <1370419185-3977-1-git-send-email-arend@broadcom.com>
 <878v2p3qst.fsf@purkki.adurom.net> <874ndd3q20.fsf@purkki.adurom.net>
In-Reply-To: <874ndd3q20.fsf@purkki.adurom.net>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/05/2013 10:44 AM, Kalle Valo wrote:
> Kalle Valo <kvalo@adurom.com> writes:
>
>> "Arend van Spriel" <arend@broadcom.com> writes:
>>
>>> This patch fixes a regression introduced by:
>>>
>>>    commit 6da3b6c48d79da96a36c2632053cf4f53bf48fb2
>>>    Author: Hauke Mehrtens <hauke@hauke-m.de>
>>>    Date:   Sun Mar 24 01:45:52 2013 +0100
>>>
>>>        brcmsmac: remove brcms_bss_cfg->associated
>>>
>>> The regression behaviour is described in:
>>>
>>> http://www.spinics.net/lists/linux-wireless/msg107474.html
>>
>> The link is not a very reliable reference, it can die anytime and
>> there's no way to know what message it refers to. Stating the message id
>> would better. And the best would be to copy the full text to the commit
>> log, it's only few lines anyway.
>
> Johannes gave a handy tip. Gmane has a service which uses message ids:
>
> http://mid.gmane.org/5197DC4F.7030503@broadcom.com
>
> If the link or service dies, one can find the email with the message id
> visible from the link.
>

What if gmane dies ;-)

Gr. AvS

