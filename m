Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34875 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab2GZGKJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2012 02:10:09 -0400
Received: by eeil10 with SMTP id l10so249970eei.19
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jul 2012 23:10:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMz9Wg8a0rAj8FN4gczfB6aUA8KgAiTc0_MG6Vc046Zmo4o0Tw@mail.gmail.com>
References: <1343267468-9986-1-git-send-email-acelan.kao@canonical.com>
 <CAGRGNgWk1wV_6Xi6jQppkBtJ+1TYRpTSQ=v8NZffqSBtJNGBYQ@mail.gmail.com> <CAMz9Wg8a0rAj8FN4gczfB6aUA8KgAiTc0_MG6Vc046Zmo4o0Tw@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 26 Jul 2012 16:09:48 +1000
Message-ID: <CAGRGNgX+QmoYhkPuPrr_c5TvqRP=hhzxOSftZh969aOFeiV28g@mail.gmail.com> (sfid-20120726_081014_458407_D86F3E13)
Subject: Re: [PATCH] Revert "rfkill: remove dead code"
To: AceLan Kao <acelan.kao@canonical.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Corentin Chary <corentincj@iksaif.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi AceLan,

On Thu, Jul 26, 2012 at 3:55 PM, AceLan Kao <acelan.kao@canonical.com> wrote:
> Dear Julian,
>
> I just submitted a patch to platform-x86 for asus-wmi.
> And the patch needs to use rfkill_set_led_trigger_name() function
> to bind the wlan led to rfkill event.

That's what I wanted to know.

I assume that you've added a note to the ASUS-WMI patch so people know
that it needs this one first. (I can't see it here so I don't know)

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
