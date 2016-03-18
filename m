Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:34705 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756855AbcCRLOa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2016 07:14:30 -0400
Received: by mail-ob0-f172.google.com with SMTP id ts10so112308482obc.1
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2016 04:14:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160318110134.GR5273@mwanda>
References: <cover.1458262312.git.julian.calaby@gmail.com> <90fe6325e407d35a18fa8c8cb7eaa269968d6426.1458262312.git.julian.calaby@gmail.com>
 <20160318110134.GR5273@mwanda>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 18 Mar 2016 22:14:09 +1100
Message-ID: <CAGRGNgUk5FM6=sCL8UULsQm9D2WtiHrd2skBRuke72h6ZgM0XA@mail.gmail.com> (sfid-20160318_121452_571382_2182FD87)
Subject: Re: [PATCH CONTROVERSIAL 19/19] iwlegacy: Rename label in il_eeprom_init()
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Markus Elfring <elfring@users.sourceforge.net>,
	Nicolas Pitre <nico@linaro.org>,
	Jia-Ju Bai <baijiaju1990@163.com>,
	Arnd Bergmann <arnd@arndb.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

On Fri, Mar 18, 2016 at 10:01 PM, Dan Carpenter
<dan.carpenter@oracle.com> wrote:
> On Fri, Mar 18, 2016 at 01:29:39PM +1100, Julian Calaby wrote:
>> From: Markus Elfring <elfring@users.sourceforge.net>
>>
>> Rename a jump label according to the current Linux coding style convention.
>>
>> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
>> [Rewrote commit title]
>> Signed-off-by: Julian Calaby <julian.calaby@gmail.com>
>>
>> ---
>>
>> This was controversial when introduced, however the change is obvious and
>> harmless and is, in the worst case, just churn.
>>
>> I'm only including this as it meets my criteria for sheparding pending
>> patches: it's sane, obviously correct or reviewable by me, and doesn't
>> require any work to apply.
>>
>> This does meet those requirements, however given how controviersial it was
>> when introduced, I'm not expecting people to be enthusiastic about
>> applying it.
>>
>> Thanks,
>
> It's a bad idea to mark this sort of patch as controversial.  It's
> bikeshed stuff.  Either apply it or don't but don't lets spend any more
> time thinking about it.
>
> Actual controversial patches have a long term impact.

Noted. I'll label anything like this (someone's done the work but it
makes no difference if it's applied) as "bikeshed" or "churn" in the
future.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
