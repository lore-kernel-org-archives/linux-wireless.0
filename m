Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:34660 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbbG1Pr2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2015 11:47:28 -0400
Received: by oigd21 with SMTP id d21so71431651oig.1
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2015 08:47:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55B79267.9020706@gmail.com>
References: <55B79267.9020706@gmail.com>
Date: Tue, 28 Jul 2015 17:47:27 +0200
Message-ID: <CAA2SeN+fUULz=CMQ04Xu2bc3aczs=ZTQ=kPt9McEWbKmsW_jvQ@mail.gmail.com> (sfid-20150728_174731_425560_CFBC8502)
Subject: Re: [RFC 0/4] mac80211: define VHT rate mask logic
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Lorenzo Bianconi wrote:
>
>> [...]
>> This patchset has been tested using mac80211/mt76 driver on
>> Buffalo WHR-1166D router running OpenWrt trunk
>
> mt76 is an out of the tree driver, included only in OpenWrt.

my router is a Buffalo WHR-1166D and AFAIK mt76 is the only open
source driver for mt7612 chipset

>
> Maybe OpenWrt people should begin sending code to upstream,
> because their tree [1] is full of patches [2] .
>

OpenWrt trunk runs compat-wireless-2015-07-21, so more or less
wireless-testing HEAD. Moreover I ported the patchset to mac80211-next
tree

> [1] http://git.openwrt.org/?p=openwrt.git
> [2] target/linux/* (target/linux/generic/patches-* specifically)
>     and package/kernel/* (package/kernel/mac80211/* for wireless)

Regards,
Lorenzo

-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep
