Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:61661 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932289AbZJNQwp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2009 12:52:45 -0400
Received: by iwn10 with SMTP id 10so3457769iwn.4
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2009 09:52:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AD5EDA4.6090303@canonical.com>
References: <43e72e890910131542k376a87c5rc30feb6491a06867@mail.gmail.com>
	<4AD51A7C.9060207@canonical.com> <43e72e890910131750s4d2cdb20o76d721087d9b3aaf@mail.gmail.com>
	<200910141131.47500.kunal.gangakhedkar@gmail.com> <43e72e890910140734j196a06f2y8905d3eb1ba1abc8@mail.gmail.com>
	<4AD5EDA4.6090303@canonical.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 14 Oct 2009 09:51:48 -0700
Message-ID: <43e72e890910140951j13c445aaw665cbadbb81d3e6a@mail.gmail.com>
Subject: Re: Stable compat-wireless 2.6.32-rc4 released
To: tim.gardner@canonical.com
Cc: Kunal Gangakhedkar <kunal.gangakhedkar@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 14, 2009 at 8:26 AM, Tim Gardner <tim.gardner@canonical.com> wrote:
> Luis R. Rodriguez wrote:
>> On Tue, Oct 13, 2009 at 11:01 PM, Kunal Gangakhedkar
>> <kunal.gangakhedkar@gmail.com> wrote:
>>> Isn't this the whole purpose of linux-backports-modules in ubuntu as well?
>>
>> Yes, but lbm currently relies on the bleeding edge compat-wireless
>> which is exactly that -- bleeding edge, it may or may not work. The
>> stable compat-wireless releases are based on the latest stable kernel
>> releases and latest rc kernel release so they are deemed to be stable
>> snapshots following the kernel release cycle.
>>
>>   Luis
>>
>
> I am currently in the process of adopting compat-wireless-2.6.32-rc4 in
> Karmic LBM.

Oh nice.

> Luis - Have I remembered to thank you for all your hard work?

I think so :) Fortunately Hauke Mehrtens and others are also
contributing to maintaining it as well. But I'll accept single malt
whiskey next time we see each other though :)

  Luis
