Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53280 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab1LUIMo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 03:12:44 -0500
Received: by dajs34 with SMTP id s34so4453495daj.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Dec 2011 00:12:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGXE3d9izM_cu=FpoYfLR1cx=tn+3BPMi9d7XEBfG-bkHR1oRA@mail.gmail.com>
References: <1324288978-27162-1-git-send-email-helmut.schaa@googlemail.com>
	<1324310130.3414.3.camel@jlt3.sipsolutions.net>
	<CAGXE3d_dH1jeSVrmANd_OARqwY_NUkKu3He6Y7mP8atzas88pA@mail.gmail.com>
	<1324312896.3414.16.camel@jlt3.sipsolutions.net>
	<CAGXE3d9izM_cu=FpoYfLR1cx=tn+3BPMi9d7XEBfG-bkHR1oRA@mail.gmail.com>
Date: Wed, 21 Dec 2011 09:12:43 +0100
Message-ID: <CAGXE3d-iHJqu1d5BCETkebR6t7VnkwpuLSi6ddyZWhtVxaE8=Q@mail.gmail.com> (sfid-20111221_091246_478220_A03E4483)
Subject: Re: [PATCH] mac80211: Fix frame classification in AP mode for relayed frames
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 20, 2011 at 9:37 AM, Helmut Schaa
<helmut.schaa@googlemail.com> wrote:
>>> So, you'd prefer to just copy over the TID as used by the source
>>> STA (via the priority+256 hack maybe)?
>>
>> Seems simpler to me really, at least right now and as default. Not sure,
>> maybe other people have more opinion? :)
>>
>> I just don't expect anyone to hack the kernel for their local policy,
>> and using what the STA wanted seems OK? If you run wifi networks you
>> kinda trust them already anyway :)
>
> Fine with me. I'll change the patch to keep the priority the STA used ...

Done. John, you can drop this one.

Thanks,
Helmut
