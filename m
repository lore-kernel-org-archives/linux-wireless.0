Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59112 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409Ab0H1U5v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Aug 2010 16:57:51 -0400
Received: by iwn5 with SMTP id 5so3640288iwn.19
        for <linux-wireless@vger.kernel.org>; Sat, 28 Aug 2010 13:57:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C782DB0.4060800@hauke-m.de>
References: <1282934453-18093-1-git-send-email-hauke@hauke-m.de> <4C782DB0.4060800@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Sat, 28 Aug 2010 13:57:20 -0700
Message-ID: <AANLkTinPuGWQ85RO8=EOTeTngjzC2KvgoXxRP8qux0-Z@mail.gmail.com>
Subject: Re: [PATCH 0/7] compat-wireless: add support for kernel 2.6.24 and 2.6.25
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 27, 2010 at 2:27 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> Am 27.08.2010 20:40, schrieb Hauke Mehrtens:
>> This series fixes some problems when compiling compat-wireless against
>> kernel 2.6.24 or 2.6.25. Now this should work for every driver selected
>> by default.
>> "add ifdefs into compat_autoconf.h" extends gen-compat-autoconf.sh to
>> handle some ifdef in config.mk.
>>
>> This was compile tested with kernel 2.6.24 to 2.6.36.
>>
>> Hauke Mehrtens (7):
>>   compat-wireless: do not use needed_headroom
>>   compat-wireless: fix patch stile.
>>   compat-wireless: remove linux/gpio.h include
>>   compat-wireless: multiple changes to config file
>>   compat-wireless: rename CONFIG_IWLWIFI config symbol
>>   compat-wireless: add ifdefs into compat_autoconf.h
>>   compat-wireless: add support for kernel 2.6.24
>
> These patches and the patch for compat should also go into stable. I
> have tested then with origin/linux-2.6.36.y and they also worked on that
> branch.

Awesome thanks, all applied cleanly on the 2.6.36.y branch except the
iwlwifi one but I manged that. Merged and pushed.

 Luis
