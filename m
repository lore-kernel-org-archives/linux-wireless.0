Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:35222 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790AbcCRKmp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2016 06:42:45 -0400
Received: by mail-ob0-f170.google.com with SMTP id fp4so111805099obb.2
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2016 03:42:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160318103124.GC24990@redhat.com>
References: <cover.1458262312.git.julian.calaby@gmail.com> <90fe6325e407d35a18fa8c8cb7eaa269968d6426.1458262312.git.julian.calaby@gmail.com>
 <20160318103124.GC24990@redhat.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 18 Mar 2016 21:42:25 +1100
Message-ID: <CAGRGNgUW2ziqNu8AcZXceKziiQFf7B5_obLNs=fA+0ixbzpGnw@mail.gmail.com> (sfid-20160318_114250_625741_FF1F85B6)
Subject: Re: [PATCH CONTROVERSIAL 19/19] iwlegacy: Rename label in il_eeprom_init()
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	Markus Elfring <elfring@users.sourceforge.net>,
	Nicolas Pitre <nico@linaro.org>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Jia-Ju Bai <baijiaju1990@163.com>,
	Arnd Bergmann <arnd@arndb.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

On Fri, Mar 18, 2016 at 9:31 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
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
>
> I don't see the sense of that change, NACK

Fair enough, I wasn't expecting this to get applied anyway.

Consider it dropped.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
