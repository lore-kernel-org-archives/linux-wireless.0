Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:6683 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600AbZCJSXX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 14:23:23 -0400
Received: by fg-out-1718.google.com with SMTP id 16so982195fgg.17
        for <linux-wireless@vger.kernel.org>; Tue, 10 Mar 2009 11:23:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890903100011s26e1c6b4m8306289766571cec@mail.gmail.com>
References: <1236651030-10331-1-git-send-email-lrodriguez@atheros.com>
	 <3ace41890903100002m341a15b6mb6a18226dff84212@mail.gmail.com>
	 <43e72e890903100011s26e1c6b4m8306289766571cec@mail.gmail.com>
Date: Tue, 10 Mar 2009 18:23:19 +0000
Message-ID: <3ace41890903101123v43d5566did4a7a85e2f57cc51@mail.gmail.com> (sfid-20090310_192327_324722_DA0B41F3)
Subject: Re: [RFC] zd1211rw: remove zd_addr_t typedef for a simple u16
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, dsd@gentoo.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 10, 2009 at 7:11 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Tue, Mar 10, 2009 at 12:02 AM, Hin-Tak Leung <hintak.leung@gmail.com> wrote:
>> On Tue, Mar 10, 2009 at 2:10 AM, Luis R. Rodriguez
>> <lrodriguez@atheros.com> wrote:
>>> The __nocast attribute is used to shut sparse up but we
>>> don't need it, lets just use u16 directly.
>>>
>>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>>> ---
>>>
>>> Can someone test this for me? The zd1211rw device seems to require
>>> a bit more tweaks to work so not sure ifs the patch, it wasn't working
>>> with zd1211rw anyway. We will release another update to the vendor driver
>>> to help with addition of new device support.
>>
>> Am I reading this correctly - an update to the vendor driver?
>
> Yeah thing is that stuff kept on moving forward internally, so no port
> work was done to move it out. Unfortunately we don't have resources to
> do it ourselves so we can hope for community involvement on porting.
>
<snipped>
> Let me see if I get time to dig through the vault.

I know commercial entities don't want to release unfinished code, but it stays
internally and behind, any internal driver code would just bit-rot,
the rate the kernel/wireless is going.

I already have the 2.4.26-27 change (and posted), and an
untested/unposted 29+ netdev_priv() change,
so merging soon would be good. (and I am available for
contracting/consultancy for more gauranteed work, if that matters).
