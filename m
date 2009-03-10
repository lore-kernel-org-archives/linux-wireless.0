Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:14113 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbZCJHLF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 03:11:05 -0400
Received: by wf-out-1314.google.com with SMTP id 28so2439118wfa.4
        for <linux-wireless@vger.kernel.org>; Tue, 10 Mar 2009 00:11:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3ace41890903100002m341a15b6mb6a18226dff84212@mail.gmail.com>
References: <1236651030-10331-1-git-send-email-lrodriguez@atheros.com>
	 <3ace41890903100002m341a15b6mb6a18226dff84212@mail.gmail.com>
Date: Tue, 10 Mar 2009 00:11:03 -0700
Message-ID: <43e72e890903100011s26e1c6b4m8306289766571cec@mail.gmail.com> (sfid-20090310_081114_980747_BA48524A)
Subject: Re: [RFC] zd1211rw: remove zd_addr_t typedef for a simple u16
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Hin-Tak Leung <hintak.leung@gmail.com>
Cc: linville@tuxdriver.com, dsd@gentoo.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 10, 2009 at 12:02 AM, Hin-Tak Leung <hintak.leung@gmail.com> wrote:
> On Tue, Mar 10, 2009 at 2:10 AM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
>> The __nocast attribute is used to shut sparse up but we
>> don't need it, lets just use u16 directly.
>>
>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>> ---
>>
>> Can someone test this for me? The zd1211rw device seems to require
>> a bit more tweaks to work so not sure ifs the patch, it wasn't working
>> with zd1211rw anyway. We will release another update to the vendor driver
>> to help with addition of new device support.
>
> Am I reading this correctly - an update to the vendor driver?

Yeah thing is that stuff kept on moving forward internally, so no port
work was done to move it out. Unfortunately we don't have resources to
do it ourselves so we can hope for community involvement on porting.

> I am using a somewhat patched vendor driver (22.0.0.0) as my access
> point, as AP mode in the rw driver isn't in sight yet.
> Am volunteering as a guinea pig if there is an update.

Great.

> v 22.0.0.0 was 2.6.24(2.6.26?) era and I updated it to 2.6.28.x and
> posted the patch to sf zd1211 ml; there is another netdev_priv()
> update for 2.6.29+ which is sitting in my hard disc and will go to my
> rather low-spec AP machine when I next rebuild the kernel...

Let me see if I get time to dig through the vault.

  Luis
