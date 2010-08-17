Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58742 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab0HQXsW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Aug 2010 19:48:22 -0400
Received: by iwn7 with SMTP id 7so1864858iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 Aug 2010 16:48:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C6B1395.2030208@hauke-m.de>
References: <1282069869-22300-1-git-send-email-hauke@hauke-m.de>
 <AANLkTinS=nXje5hJ=Eq4AuXvMUEhDbquB=C_oDXA+pHk@mail.gmail.com> <4C6B1395.2030208@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 17 Aug 2010 16:48:01 -0700
Message-ID: <AANLkTik21gw2ngJ8DtxVXdVXS6KAH_Y3a8gPEZWf1975@mail.gmail.com>
Subject: Re: [PATCH 0/3] compat-wireless: miscellaneous fixes
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 17, 2010 at 3:56 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> Am 18.08.2010 00:02, schrieb Luis R. Rodriguez:
>> On Tue, Aug 17, 2010 at 11:31 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>>> This was build tested in combination with the patches to compat.
>>>
>>> Hauke Mehrtens (3):
>>>  compat-wireless: deactivate namespace
>>>  compat-wireless: make compat-2.6.37.c build
>>>  compat-wireless: fix hidp_output_raw_report
>>
>> Great thanks! Applied and pushed all out. Are any of these stable
>> fixes into the respective stable branches of compat-wireless.git? How
>> about the compat.git ones?
>>
>>   Luis
>
> Thanks for applying.
>
> Only compat-wireless: fix hidp_output_raw_report is needed in stable.
> The other patches are not needed in stable for now, they are for some
> changes made after 2.6.36.

OK cool, pushed this in for a new stable release for 2.6.36-rc1 so we
get a -2 now:

http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.36/compat-wireless-2.6.36-rc1-2.tar.bz2

  Luis
