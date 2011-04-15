Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42170 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941Ab1DOBQY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2011 21:16:24 -0400
Received: by iyb14 with SMTP id 14so1847479iyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Apr 2011 18:16:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTimFpfiufv09raZNOLX30Ot6fdZV1Q@mail.gmail.com>
References: <4DA606CC.9040609@hauke-m.de> <77733.17144.qm@web161604.mail.bf1.yahoo.com>
 <BANLkTimFpfiufv09raZNOLX30Ot6fdZV1Q@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 14 Apr 2011 18:16:02 -0700
Message-ID: <BANLkTintXt40gCUEW2Mf0eGEQdUT7QB9zA@mail.gmail.com>
Subject: Re: Compat-wireless release for 2011-04-07 is baked
To: Walter Goldens <goldenstranger@yahoo.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 14, 2011 at 8:38 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Thu, Apr 14, 2011 at 8:32 AM, Walter Goldens
> <goldenstranger@yahoo.com> wrote:
>>> The cron job generating compat-wireless places it to a
>>> location, so it
>>> is available for download on orbit, the cron job is running
>>> on a server
>>> at orbit. Now some other cron job copies it to
>>> wireless.kernel.org.
>>>
>>> The scripts generating compat-wireless can be found here:
>>> http://git.kernel.org/?p=linux/kernel/git/mcgrof/compat-user.git;a=tree
>>
>>
>> Thanks for clearing this up, Hauke. There hasn't been one single compat-wireless tar ball for the month of April.
>>
>>
>>> > PS, I guess this CW bot "baker" needs a little
>>> fine-tuning
>>> Yes that's true. Are you willing to improve it so it
>>> generated better
>>> messages on failure?
>>
>> I'm willing, but I've got my hands full right now. Luis is maintaining this, isn't he? I think he's away now. Maybe he'd like to check with his own creations.
>
> I'm not away, just doing other things. Will check this out today.

OK fixed, lets see what this thing spits out tomorrow, but I think it
should be fixed.

  Luis
