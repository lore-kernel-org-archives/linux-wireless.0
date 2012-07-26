Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:64579 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916Ab2GZFzj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2012 01:55:39 -0400
Received: by vbbff1 with SMTP id ff1so1325934vbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jul 2012 22:55:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGRGNgWk1wV_6Xi6jQppkBtJ+1TYRpTSQ=v8NZffqSBtJNGBYQ@mail.gmail.com>
References: <1343267468-9986-1-git-send-email-acelan.kao@canonical.com>
	<CAGRGNgWk1wV_6Xi6jQppkBtJ+1TYRpTSQ=v8NZffqSBtJNGBYQ@mail.gmail.com>
Date: Thu, 26 Jul 2012 13:55:38 +0800
Message-ID: <CAMz9Wg8a0rAj8FN4gczfB6aUA8KgAiTc0_MG6Vc046Zmo4o0Tw@mail.gmail.com> (sfid-20120726_075551_100195_8C3EB34F)
Subject: Re: [PATCH] Revert "rfkill: remove dead code"
From: AceLan Kao <acelan.kao@canonical.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Corentin Chary <corentincj@iksaif.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Julian,

I just submitted a patch to platform-x86 for asus-wmi.
And the patch needs to use rfkill_set_led_trigger_name() function
to bind the wlan led to rfkill event.

There is no other way to set the ledtrigname if rfkill.c doesn't provide
a function for it.

Best regards,
AceLan Kao.

2012/7/26 Julian Calaby <julian.calaby@gmail.com>:
> Hi AceLan,
>
> On Thu, Jul 26, 2012 at 11:51 AM, AceLan Kao <acelan.kao@canonical.com> wrote:
>> This reverts commit 2e48928d8a0f38c1b5c81eb3f1294de8a6382c68.
>>
>> Those functions are needed and should not be removed, or
>> there is no way to set the rfkill led trigger name.
>
> Who or what is using these functions?
>
> As I understand it, they wouldn't have been removed if any upstream
> code was using them.
>
> Thanks,
>
> --
> Julian Calaby
>
> Email: julian.calaby@gmail.com
> Profile: http://www.google.com/profiles/julian.calaby/
> .Plan: http://sites.google.com/site/juliancalaby/



-- 
Chia-Lin Kao(AceLan)
http://blog.acelan.idv.tw/
E-Mail: acelan.kaoATcanonical.com (s/AT/@/)
