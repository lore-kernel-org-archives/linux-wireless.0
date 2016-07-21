Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:32853 "EHLO
	mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbcGUIad convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2016 04:30:33 -0400
Received: by mail-lf0-f54.google.com with SMTP id b199so55173919lfe.0
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jul 2016 01:30:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAD3r-iQScbuUiGiF3uDKzMk-0mycG3WVFDGaYCy6aPxAEjq3mg@mail.gmail.com>
References: <CAEOnXSfd6K36cOcUfqy8rBT27TbH9PGy7U4z3TU0N2YWc7GXqA@mail.gmail.com>
 <efa3441022124e74af56753a70041eee@SC-EXCH04.marvell.com> <CAD3r-iQScbuUiGiF3uDKzMk-0mycG3WVFDGaYCy6aPxAEjq3mg@mail.gmail.com>
From: Nestor Machno <nestor.machno89@gmail.com>
Date: Thu, 21 Jul 2016 10:30:30 +0200
Message-ID: <CAEOnXSduqnuKU1S4jcxN=K-JxwWfWxG6WWtiGzZvuW_pwWGM+A@mail.gmail.com> (sfid-20160721_103038_792875_83D1852F)
Subject: Re: mwifiex+wpa_supplicant cannot set up WPA/WPA2 ADHOC
To: Luana Borgia <luanaborgia1969@gmail.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luana,
as confirmed by Marvell this is a firmware issue and the firmware is
not free/open so only Marvell is able to fix it.
At the moment the latest firmware available is still the 15.68.7.p5, aka p5.
http://git.marvell.com/?p=mwifiex-firmware.git;a=tree;f=mrvl;hb=HEAD
Unfortunately in this case the community can't give you support..

Regards
Nestor

2016-07-20 15:23 GMT+02:00 Luana Borgia <luanaborgia1969@gmail.com>:
> Hi Amitkumar,
> any news about this issue? I've the same problem also..
>
> Security a part, we can't leave the WIFI open or just with WEP because
> we get too many not trusted connection that consume a lot of our
> bandwidth
>
> Thanks, regards
> Luana
>
> 2016-07-08 11:15 GMT+02:00 Amitkumar Karwar <akarwar@marvell.com>:

>> Yes. This is a bug in our firmware. ADHOC in WPA/WPA2 security is broken. We have asked firmware experts to look into this. As we have a mid-year shutdown this week, they will be able to check the problem next week only. However ADHOC in open mode should work as expected
>>
>>
>> Regards,
>> Amitkumar
