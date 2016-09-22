Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:35707 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750778AbcIVExb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Sep 2016 00:53:31 -0400
Received: by mail-oi0-f41.google.com with SMTP id w11so85304044oia.2
        for <linux-wireless@vger.kernel.org>; Wed, 21 Sep 2016 21:53:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <57E35BA9.7050207@candelatech.com>
References: <CAArymCks5NN=09EdJ4uaoRrHZciYAkYTES+i62BkfZ4R-W30HQ@mail.gmail.com>
 <96b0636d-1171-5830-6481-edb991ca8e1a@rempel-privat.de> <CAArymCnJZgUbgCiLqA6-94RAtXYkYeeS9uF71MX9+ou-AbYszg@mail.gmail.com>
 <57E35BA9.7050207@candelatech.com>
From: bruce m beach <brucembeach@gmail.com>
Date: Wed, 21 Sep 2016 21:53:29 -0700
Message-ID: <CAArymC=VT+1E=-ug1yaVquW0jVvbFfZ0USzRcsRD62tSR-9FRA@mail.gmail.com> (sfid-20160922_065334_944103_34BC91EC)
Subject: Re: ath9k_htc kernel driver regression affecting throughput
To: Ben Greear <greearb@candelatech.com>
Cc: Oleksij Rempel <linux@rempel-privat.de>,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

memory will be very tight. There is 160k or known ram and bits and pieces
elsewhere. The rom is 24k (maximum). I currently am not to worried about
it. (although I am watching it)
bruce

On 9/21/16, Ben Greear <greearb@candelatech.com> wrote:
>
>
> On 09/21/2016 08:34 PM, bruce m beach wrote:
>
>>>> i.e a lable that the code jumps to and nothing else. At this point I
>>>> have
>>>> added VendorCommand(), and a debugger via ep0. ( ep0 is a good choice
>>>> since it is available a boot, no matter what) and over the next few
>>>> months I am going to move ->all<- the rom code into ram starting with
>>>> the USB subsystem.
>
> Have you investigated whether you have enough RAM to do this?
>
> I haven't looked at ath9k_htc, but in general, that type of architecture
> is tight on RAM in my experience.
>
> Thanks,
> Ben
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>
