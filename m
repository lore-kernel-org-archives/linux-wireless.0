Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f178.google.com ([209.85.222.178]:46819 "EHLO
	mail-pz0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbZH1PVR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2009 11:21:17 -0400
Received: by pzk8 with SMTP id 8so2055009pzk.22
        for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2009 08:21:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090827135216.GB2961@tuxdriver.com>
References: <87k50plbd8.fsf@nokia.com> <20090827135216.GB2961@tuxdriver.com>
Date: Fri, 28 Aug 2009 20:51:19 +0530
Message-ID: <683e2de40908280821v70ab4ab1id9555ccc98ba4fc5@mail.gmail.com>
Subject: Re: Nokia N900 running mac80211
From: Paresh Sawant <paresh.sawant@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Is this information officially published that N900 uses mac80211 with
kernel 2.6.28 ?


Thanks
- Paresh

On Thu, Aug 27, 2009 at 7:22 PM, John W. Linville<linville@tuxdriver.com> wrote:
> On Thu, Aug 27, 2009 at 02:55:31PM +0300, Kalle Valo wrote:
>> Hello,
>>
>> wanted to tell you that just released Nokia N900 is using mac80211 and
>> wl1251 driver. The kernel is 2.6.28 with few wireless related patches
>> backported from newer releases and some hacks related to roaming.
>>
>> http://www.nokia.com/press/press-releases/showpressrelease?newsid=1337594
>
> Hey, that is cool!  Let's hope other manufacturers learn to embrace
> the open code in the kernel and abandon closed-source options that
> merely reimplement functionality that we already provide.
>
> Let's also hope that this continues to motivate Nokia to support you
> are your coworkers in making strong contributions to the kernel in
> wireless and other areas.
>
> Thanks!
>
> John
> --
> John W. Linville                Someday the world will need a hero, and you
> linville@tuxdriver.com                  might be all we have.  Be ready.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
