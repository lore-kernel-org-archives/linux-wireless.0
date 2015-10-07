Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:15753 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825AbbJGT5T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2015 15:57:19 -0400
Message-ID: <5615791C.4060709@broadcom.com> (sfid-20151007_215726_705040_8F6A3C19)
Date: Wed, 7 Oct 2015 21:57:16 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Kyle McMartin <kyle@infradead.org>
CC: <linux-wireless@vger.kernel.org>, Rafal Milecki <zajec5@gmail.com>
Subject: Re: [PATCH] brcmfmac: firmware refresh for BCM43602 PCIE devices
References: <1443120304-11153-1-git-send-email-arend@broadcom.com> <20150925000004.GF26918@merlin.infradead.org> <560C139B.7040604@broadcom.com> <20151007174855.GI26918@merlin.infradead.org>
In-Reply-To: <20151007174855.GI26918@merlin.infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/07/2015 07:48 PM, Kyle McMartin wrote:
> On Wed, Sep 30, 2015 at 06:53:47PM +0200, Arend van Spriel wrote:
>> On 09/25/2015 02:00 AM, Kyle McMartin wrote:
>>> On Thu, Sep 24, 2015 at 08:45:04PM +0200, Arend van Spriel wrote:
>>>> A number of end-users reported issues with BCM43602 on the 2015
>>>> MacBook Pro. It turned out the previously released firmware did
>>>> not properly support that device [1]. Hence an update of the STA
>>>> firmware and while at it refresh the AP firmware as well. The
>>>> latter has been tested using Netgear R8000. The STA firmware has
>>>> been tested on MacBook Pro.
>>>>
>>>
>>> Are there version numbers we could update in WHENCE to make this
>>> easier to track?
>>
>> Hi Kyle,
>>
>> For brcmfmac firmware we do not have version numbers in the WHENCE file. The
>> firmware file itself contains the version number which can be shown using
>> hexdump. I can make a note of that fact in the WHENCE file if needed.
>>
>
> Sorry, I meant to apply this a few days ago, but I finally pushed it
> out. Thanks for your patience.

No problem.

Thanks,
Arend

> regards, --Kyle
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

