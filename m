Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:34200 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751907AbdANLxX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 14 Jan 2017 06:53:23 -0500
Received: by mail-wm0-f50.google.com with SMTP id f73so18218533wmf.1
        for <linux-wireless@vger.kernel.org>; Sat, 14 Jan 2017 03:53:22 -0800 (PST)
Subject: Re: linux driver bcm4311 failure
To: message <letter@openmailbox.org>,
        brcm80211-dev-list.pdl@broadcom.com, arch-general@archlinux.org,
        linux-wireless <linux-wireless@vger.kernel.org>
References: <257e6d7f8b199e444164fae07dd569e1@openmailbox.org>
 <fe03ef16-998d-3819-2092-45f30f7b4555@broadcom.com>
 <b9128b3f27d585ff2da2ff83e02c3f11@openmailbox.org>
 <79259801571260a330b01a8d092d9d48@openmailbox.org>
 <c7893ec092e40d89a3f001bd2fd4f54c@openmailbox.org>
 <a7c6682e-2515-b0e9-c4a9-743e8780257a@broadcom.com>
 <851aa49795494ec407c4783f8579437e@openmailbox.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <da82a20d-fad4-69e4-c2bc-6cee1374253d@broadcom.com> (sfid-20170114_125335_161412_CD1AADE6)
Date: Sat, 14 Jan 2017 12:53:18 +0100
MIME-Version: 1.0
In-Reply-To: <851aa49795494ec407c4783f8579437e@openmailbox.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14-1-2017 11:15, message wrote:
> On 2017-01-02 20:04, Arend van Spriel wrote:
>> On 02-01-17 15:33, message wrote:
>>> On 2016-12-30 19:46, message wrote:
>>>> On 2016-09-17 08:11, message wrote:
>>>>> On 2016-09-09 07:57, Arend Van Spriel wrote:
>>>>>>
>>>>>> The device is claimed by b43-pci-bridge so I would suggest:
>>>>>>
>>>>>> blacklist b43-pci-bridge
>>>>>>
>>>
>>> The wifi card indicator now appears to start after computer switch on
>>> (twice in a row now!)
>>>
>>> Neither networkmanager or wicd are accepting the password.
>>>
>>> Even:
>>>
>>> wicd-cli --wireless -c [wifihotspotname]
>>> done!
>>>
>>> is false and internet access not found.
>>>
>>> wpa_supplicant continues to report 'conn_failed' error.
>>>
>>> Connection to same network is successful using debian on chromebook
>>> (crouton)
>>
>> I am confused by all your messages. In the previous one you did a
>> 'modprobe b43'. So what driver do you intend to use here. b43 is not a
>> driver maintained by broadcom. You should ask for help on the b43
>> mailing list [1] if you want to use that driver.
>>
>> Regards,
>> Arend
>>
>> [1] http://lists.infradead.org/mailman/listinfo/b43-dev
> 
> After system upgrade, wifi card fails to be recognised.
> 
> For the benefit of other users: save your time and avoid broadcom
> products; they are terrible.

Why sending these types of messages hiding in anonymity without
responding to any of the questions in my email responses. Again what
driver are you using. If it is b43 you want you should not blacklist
b43-pci-bridge. Whether or not b43 supports your device can be found
here [2]. Supposedly it is. If not you might try your luck at the b43
mailing list I gave you in earlier email.

Regards,
Arend

[2] https://wireless.wiki.kernel.org/en/users/drivers/b43#list_of_hardware
