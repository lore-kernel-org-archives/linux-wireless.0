Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:36454 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932810Ab2GLSpL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 14:45:11 -0400
Received: by ghrr11 with SMTP id r11so2761707ghr.19
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jul 2012 11:45:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1342106081.4531.29.camel@jlt3.sipsolutions.net>
References: <1341940991-11234-1-git-send-email-rodrigue@qca.qualcomm.com> <1342106081.4531.29.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Thu, 12 Jul 2012 11:44:50 -0700
Message-ID: <CAB=NE6Umwmz2iiy+kvpGsc8H1G8NBa5n21v9Wiu7V3-v3q5bmg@mail.gmail.com> (sfid-20120712_204519_946561_1CACD8DC)
Subject: Re: [PATCH v4 0/5] cfg80211: onus and cell base station hint
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	kvalo@qca.qualcomm.com, arend@broadcom.com, henry@logout.com,
	senthilb@qca.qualcomm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 12, 2012 at 8:14 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2012-07-10 at 10:23 -0700, Luis R. Rodriguez wrote:
>> From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
>>
>> These address the latest feedback on the v3 series. I've added
>> two more patches to address removing of a superflous call
>> given the introduction of wiphy_regulatory_register().
>>
>> Luis R. Rodriguez (5):
>>   cfg80211: add CONFIG_CFG80211_CERTIFICATION_ONUS
>>   cfg80211: add cellular base station regulatory hint support
>>   cfg80211: rename reg_device_remove() to wiphy_regulatory_deregister()
>>   cfg80211: make regulatory_update() static
>>   cfg80211: remove regulatory_update()
>
> Could you rebase on mac80211-next? These don't seem to apply, due to
> some overlapping changes in nl80211.h.
>
> Also, generally I would prefer to have the cleanups first. You could
> have changed regulatory_update -> wiphy_regulatory_register first and
> then not have the intermediate step with two functions called from the
> core? But if you don't want to change it now that's fine too.

I'm lazy, and since you're OK with it, I'll just send a respin.

John -- I won't send a respin of the device driver updates given that
they should apply fine after these get sucked in.

 Luis
