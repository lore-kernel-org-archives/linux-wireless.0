Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:34645 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112AbcCSNRO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Mar 2016 09:17:14 -0400
Received: by mail-oi0-f48.google.com with SMTP id l76so19632112oig.1
        for <linux-wireless@vger.kernel.org>; Sat, 19 Mar 2016 06:17:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160318145326.GS5273@mwanda>
References: <cover.1458262312.git.julian.calaby@gmail.com> <01ae52425e9dba9f82f8d107da02a0d2cd23f09d.1458262312.git.julian.calaby@gmail.com>
 <56EC057A.9000804@users.sourceforge.net> <CAGRGNgUY+fr2vaJ=uUhqzGRMCLmyKn+2QTJGD8copXgCYv8YPA@mail.gmail.com>
 <20160318145326.GS5273@mwanda>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Sun, 20 Mar 2016 00:16:54 +1100
Message-ID: <CAGRGNgVrXGsrYMqchxdo1tK+N3e2=aNeTwd=UGTAO7YPX8LGyA@mail.gmail.com> (sfid-20160319_141721_253544_21ABB746)
Subject: Re: [PATCH 08/19] iwlegacy: Return directly if allocation fails in il_eeprom_init()
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: SF Markus Elfring <elfring@users.sourceforge.net>,
	Kalle Valo <kvalo@codeaurora.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Jia-Ju Bai <baijiaju1990@163.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

On Sat, Mar 19, 2016 at 1:53 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Sat, Mar 19, 2016 at 01:33:16AM +1100, Julian Calaby wrote:
>> Hi Markus,
>>
>> On Sat, Mar 19, 2016 at 12:41 AM, SF Markus Elfring
>> <elfring@users.sourceforge.net> wrote:
>> >> Also remove an unused label.
>> >
>> > Is such a commit message a bit too short?
>>
>> I don't think so, but I don't decide these sorts of things.
>>
>> Does anyone else have an opinion on this?
>
> This is certainly not something where we need to redo the patch but
> since you asked for the future.  A lot of web archives put the subject
> and the body of the email far apart:
>
> http://marc.info/?l=linux-wireless&m=145826783627087&w=2
>
> lkml.org is the same way.
>
> It makes these types of patch descriptions awkward.

Makes sense, I'll try to avoid descriptions like this in the future.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
