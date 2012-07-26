Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56531 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab2GZGTX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2012 02:19:23 -0400
Received: by pbbrp8 with SMTP id rp8so2702757pbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jul 2012 23:19:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGRGNgX+QmoYhkPuPrr_c5TvqRP=hhzxOSftZh969aOFeiV28g@mail.gmail.com>
References: <1343267468-9986-1-git-send-email-acelan.kao@canonical.com>
	<CAGRGNgWk1wV_6Xi6jQppkBtJ+1TYRpTSQ=v8NZffqSBtJNGBYQ@mail.gmail.com>
	<CAMz9Wg8a0rAj8FN4gczfB6aUA8KgAiTc0_MG6Vc046Zmo4o0Tw@mail.gmail.com>
	<CAGRGNgX+QmoYhkPuPrr_c5TvqRP=hhzxOSftZh969aOFeiV28g@mail.gmail.com>
Date: Thu, 26 Jul 2012 14:19:23 +0800
Message-ID: <CAMz9Wg8eMTJcmd5tcxBURP3Rmuu4siEFTBDqW1aK8rqdZ8utqA@mail.gmail.com> (sfid-20120726_081952_204774_4781A1CB)
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

Yes, I have said that the asus-wmi patch needs this commit
and CC'd the asus-wmi maintainer, Corentin Chary, here in this rfkill patch.

Best regards,
AceLan Kao.

2012/7/26 Julian Calaby <julian.calaby@gmail.com>:
> Hi AceLan,
>
> On Thu, Jul 26, 2012 at 3:55 PM, AceLan Kao <acelan.kao@canonical.com> wrote:
>> Dear Julian,
>>
>> I just submitted a patch to platform-x86 for asus-wmi.
>> And the patch needs to use rfkill_set_led_trigger_name() function
>> to bind the wlan led to rfkill event.
>
> That's what I wanted to know.
>
> I assume that you've added a note to the ASUS-WMI patch so people know
> that it needs this one first. (I can't see it here so I don't know)
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
