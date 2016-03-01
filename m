Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f195.google.com ([209.85.213.195]:32830 "EHLO
	mail-ig0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbcCAAE7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 19:04:59 -0500
Received: by mail-ig0-f195.google.com with SMTP id hb3so727075igb.0
        for <linux-wireless@vger.kernel.org>; Mon, 29 Feb 2016 16:04:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <wrfja8mjhy7q.fsf@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
 <1456783551-28315-107-git-send-email-Jes.Sorensen@redhat.com>
 <CAGRGNgUYaoRoXAXOcdyxwnFNhW15_D=HGDVHVd5UAVVqS+h5MQ@mail.gmail.com> <wrfja8mjhy7q.fsf@redhat.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 1 Mar 2016 11:04:39 +1100
Message-ID: <CAGRGNgWRZFpMiVOE5Ri=uOH-+PoHApGPMQRHk=ssx=+yFWvH-w@mail.gmail.com> (sfid-20160301_010504_433473_5075E8E5)
Subject: Re: [PATCH 106/113] rtl8xxxu: convert rtl8723bu_init_bt() into rtl8723b_enable_rf()
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jes,

On Tue, Mar 1, 2016 at 10:51 AM, Jes Sorensen <Jes.Sorensen@redhat.com> wrote:
> Julian Calaby <julian.calaby@gmail.com> writes:
>> Hi Jes,
>>
>> On Tue, Mar 1, 2016 at 9:05 AM,  <Jes.Sorensen@redhat.com> wrote:
>>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>>>
>>> rtl8723bu_init_bt() is effectively the function enabling RF, so name
>>> it appropriately.
>>
>> Should this be merged into the patches that introduce these functions?
>
> Again, this would be rewriting history and simply cause me to fight a
> pile of patch conflicts rebasing things, for no gain, and at the risk of
> introducing new errors in the process.

Totally agree, this is definitely something that would cause conflicts.

IMHO, history is only important if multiple people have contributed to
something or it's being developed in public - which, for Linux, I
define as it being in a maintainer's repository.

This patch set looks like you've been playing around with a bunch of
stuff, completed *bu support, then just thrown it all over the wall
without "prettying" it up for review and submission. If I were
developing this I'd have happily rewritten history even if all I did
was reduce the number of patches by squashing later fixes into earlier
patches.

I can see a lot of scope for reducing the number of patches in this
patch set, so if you'd like me to play around with that, just ask.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
