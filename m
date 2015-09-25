Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:37298 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932764AbbIYSMH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2015 14:12:07 -0400
Received: by wicfx3 with SMTP id fx3so29892696wic.0
        for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2015 11:12:05 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: firmware refresh for BCM43602 PCIE devices
To: Kyle McMartin <kyle@infradead.org>,
	Arend van Spriel <arend@broadcom.com>
References: <1443120304-11153-1-git-send-email-arend@broadcom.com>
 <20150925000004.GF26918@merlin.infradead.org>
Cc: linux-wireless@vger.kernel.org, Rafal Milecki <zajec5@gmail.com>
From: Arend van Spriel <aspriel@gmail.com>
Message-ID: <56058E74.3060503@gmail.com> (sfid-20150925_201211_757065_F00F115A)
Date: Fri, 25 Sep 2015 20:12:04 +0200
MIME-Version: 1.0
In-Reply-To: <20150925000004.GF26918@merlin.infradead.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 25-09-15 02:00, Kyle McMartin wrote:
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

For brcmfmac firmware we don't have version numbers in WHENCE. To be
honest it feels a bit redundant as the firmware file itself contains the
version number, ie. by doing 'hexdump -C /firmware/ | tail -30'.

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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
