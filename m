Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f52.google.com ([209.85.213.52]:34010 "EHLO
	mail-vk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638AbbLDBxj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2015 20:53:39 -0500
Received: by vkbs1 with SMTP id s1so57225681vkb.1
        for <linux-wireless@vger.kernel.org>; Thu, 03 Dec 2015 17:53:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CANUX_P3WRatRnY7Mciv_W0-azk86uHsFThXYu=+QgCu8qw=GAg@mail.gmail.com>
References: <CAF7g2REe-gFm9y2SsXz5nSn9ofHevNkr80YNV720W+XB815qsA@mail.gmail.com>
 <CANUX_P3WRatRnY7Mciv_W0-azk86uHsFThXYu=+QgCu8qw=GAg@mail.gmail.com>
From: Kobi Cohen-Arazi <kobi.cohenarazi@gmail.com>
Date: Thu, 3 Dec 2015 17:52:59 -0800
Message-ID: <CAF7g2RFA8R7W+cAqpURz3ri4njkhmpuPRX7_nL8ZWfj5E3E7sg@mail.gmail.com> (sfid-20151204_025353_529916_2044E128)
Subject: Re: iw set txpower error
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 3, 2015 at 11:57 AM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
> On Thu, Dec 3, 2015 at 8:10 PM, Kobi Cohen-Arazi
> <kobi.cohenarazi@gmail.com> wrote:
>> Hi all,
>>
>> I’m trying to change txpower with iw. Using AR9580 HW + ath9k driver
>> with Kernel 4.1.6.
>>
>> The call fails in mac80211 with the following error: "Failed
>> check-sdata-in-driver check, flags: 0x0".
>> stack:
>> ---------------------------------  start stack
>
> Try that one:
>
> https://kernel.googlesource.com/pub/scm/linux/kernel/git/jberg/mac80211/+/5ad11b50fda1306b5317124f97f0a7a4c022b022

Works perfect. thanks!

Kobi
