Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.openmailbox.org ([62.4.1.33]:55686 "EHLO
	mail2.openmailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbbDEIy3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Apr 2015 04:54:29 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail2.openmailbox.org (Postfix) with ESMTP id D4F1B202771
	for <linux-wireless@vger.kernel.org>; Sun,  5 Apr 2015 10:54:28 +0200 (CEST)
Received: from mail2.openmailbox.org ([62.4.1.33])
	by localhost (mail.openmailbox.org [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id poWmQ1IAXZFO for <linux-wireless@vger.kernel.org>;
	Sun,  5 Apr 2015 10:54:27 +0200 (CEST)
Message-ID: <5520FC75.7010008@openmailbox.org> (sfid-20150405_105433_230548_E5233E94)
Date: Sun, 05 Apr 2015 17:12:21 +0800
From: Etna <etna@openmailbox.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: MediaTek WiFi hardware support in upstream kernel
References: <544DB5A8.7090405@openmailbox.org>	<20141027152026.GB19976@tuxdriver.com>	<544E8CB4.3000607@rempel-privat.de>	<20141028134608.GA26283@tuxdriver.com>	<544FA303.5060303@broadcom.com>	<544FA627.3000004@rempel-privat.de>	<5450BEB2.60208@openwrt.org>	<5461F937.9060004@rempel-privat.de>	<5463CB6C.3030204@openwrt.org>	<5463D28F.9080106@lwfinger.net>	<20150206182915.7467bac7@north>	<54EF261E.4040109@gmail.com> <20150226154028.380b96f2@north> <5520FB36.8050301@openmailbox.org>
In-Reply-To: <5520FB36.8050301@openmailbox.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is sorely needed given the miserable state of wifi drivers in the 
Linux kernel.

Kernel maintainers, can this be pushed to mainline? It's not a vendor 
driver after all, and it uses nl80211 instead of WEXT.


Regards,
Etna
>
>
> On 26/02/15 22:40, Jakub Kiciński wrote:
>>
>> On Thu, 26 Feb 2015 14:56:46 +0100, poma wrote:
>>>
>>> On 06.02.2015 18:29, Jakub Kiciński wrote:
>>>>
>>>> Hello everyone! I put together a mac80211 driver for Mediatek 
>>>> MT7601U. It's partially based on Felix's mt76, but I'm not sure if 
>>>> it will make sense to merge the two together. MT7601U is a pretty 
>>>> old 1x1 bgn chip for USB dongles and mt76 now only supports the 
>>>> latest and greatest ac APs. I'm testing STA functionality right now 
>>>> and it seems to be working ok. The code is very much a work in 
>>>> progress but if anyone is interested you can get it here: 
>>>> https://github.com/kuba-moo/mt7601uCheers, kuba -- To unsubscribe 
>>>> from this list: send the line "unsubscribe linux-wireless" in the 
>>>> body of a message to majordomo@vger.kernel.orgMore majordomo info 
>>>> at http://vger.kernel.org/majordomo-info.html
>>>
>>> How many mt7601u module editions exists there? :) - vendor's - 
>>> vendor's patched (how many forms of the same) - your reinvented - 
>>> the one on which pán Gruszka allegedly works? - any more?
>>
>> I assume you mean to ask how many different drivers are there. There 
>> is the vendor 3.0.0.4 STA driver which only has client functionality. 
>> Many patched versions of this driver exist on GitHub. There is also 
>> an older version of vendor driver which can work as an AP. My 
>> mac80211-based driver is the only non-vendor version I'm aware of.
>

