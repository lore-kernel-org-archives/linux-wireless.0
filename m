Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:58660 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314AbbI3Qxu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 12:53:50 -0400
Message-ID: <560C139B.7040604@broadcom.com> (sfid-20150930_185354_466190_81B3C9AE)
Date: Wed, 30 Sep 2015 18:53:47 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Kyle McMartin <kyle@infradead.org>
CC: <linux-wireless@vger.kernel.org>, Rafal Milecki <zajec5@gmail.com>
Subject: Re: [PATCH] brcmfmac: firmware refresh for BCM43602 PCIE devices
References: <1443120304-11153-1-git-send-email-arend@broadcom.com> <20150925000004.GF26918@merlin.infradead.org>
In-Reply-To: <20150925000004.GF26918@merlin.infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/25/2015 02:00 AM, Kyle McMartin wrote:
> On Thu, Sep 24, 2015 at 08:45:04PM +0200, Arend van Spriel wrote:
>> A number of end-users reported issues with BCM43602 on the 2015
>> MacBook Pro. It turned out the previously released firmware did
>> not properly support that device [1]. Hence an update of the STA
>> firmware and while at it refresh the AP firmware as well. The
>> latter has been tested using Netgear R8000. The STA firmware has
>> been tested on MacBook Pro.
>>
>
> Are there version numbers we could update in WHENCE to make this
> easier to track?

Hi Kyle,

For brcmfmac firmware we do not have version numbers in the WHENCE file. 
The firmware file itself contains the version number which can be shown 
using hexdump. I can make a note of that fact in the WHENCE file if needed.

Regards,
Arend

> regards, --jkkm
>
>> [1] https://bugzilla.kernel.org/show_bug.cgi?id=100201
>>
>> Cc: Rafal Milecki <zajec5@gmail.com>
>> Tested-by: Knuth Posern <knuth@posern.org>
>> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
>> Signed-off-by: Arend van Spriel <arend@broadcom.com>
>> ---
>> This patch fixes a couple of issues mentioned in kernel bugzilla
>> #100201 with 2015 MacBook Pro machines using this wifi chipset.
>>
>> The patch applies to master branch of the linux-firmware repository
>> on top of commit f88e5c2e2ff5 ("Merge 'c11384c' of
>> git://people.freedesktop.org/~vivijim/linux-firmware...").

