Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f193.google.com ([209.85.217.193]:44574 "EHLO
        mail-ua0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965931AbeEIXBK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 19:01:10 -0400
Received: by mail-ua0-f193.google.com with SMTP id h15-v6so117634uan.11
        for <linux-wireless@vger.kernel.org>; Wed, 09 May 2018 16:01:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180509205544.GW27853@wotan.suse.de>
References: <20180508181247.19431-1-mcgrof@kernel.org> <20180508181247.19431-6-mcgrof@kernel.org>
 <CAGXu5jJXMxx2Xna_M_g1wsS59XnYKqHAGdxhzDtk3PhnLL-gQQ@mail.gmail.com> <20180509205544.GW27853@wotan.suse.de>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 9 May 2018 16:01:09 -0700
Message-ID: <CAGXu5jLn0m_9j=r=x1JefRVEYMvR4Q--e8pCufZyoVQkWe507A@mail.gmail.com> (sfid-20180510_010125_706358_4C611A05)
Subject: Re: [PATCH v6 05/13] firmware_loader: enhance Kconfig documentation
 over FW_LOADER
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>, maco@android.com,
        Andy Gross <andy.gross@linaro.org>,
        David Brown <david.brown@linaro.org>,
        bjorn.andersson@linaro.org, Tom Gundersen <teg@jklm.no>,
        wagi@monom.org, Hans de Goede <hdegoede@redhat.com>,
        Andres Rodriguez <andresx7@gmail.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Jakub Kicinski <kubakici@wp.pl>, Shuah Khan <shuah@kernel.org>,
        Martin Fuzzey <mfuzzey@parkeon.com>,
        David Howells <dhowells@redhat.com>, pali.rohar@gmail.com,
        Takashi Iwai <tiwai@suse.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Nicolas Broeking <nbroeking@me.com>,
        Vikram Mulukutla <markivx@codeaurora.org>,
        Mark Brown <broonie@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Abhay_Salunke@dell.com, jewalt@lgsinnovations.com,
        oneukum@suse.com, Bitterblue of Monsea <cantabile.desu@gmail.com>,
        Alexei Starovoitov <ast@fb.com>, hare <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>, khc@pm.waw.pl,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        tkjos@android.com, Jonathan Corbet <corbet@lwn.net>,
        mchehab+samsung@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-scsi@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 9, 2018 at 1:55 PM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> On Tue, May 08, 2018 at 03:42:33PM -0700, Kees Cook wrote:
>> On Tue, May 8, 2018 at 11:12 AM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
>> > +         This used to be the default firmware loading facility, and udev used
>> > +         to listen for uvents to load firmware for the kernel. The firmware
>> > +         loading facility functionality in udev has been removed, as such it
>> > +         can no longer be relied upon as a fallback mechanism. Linux no longer
>> > +         relies on or uses a fallback mechanism in userspace. If you need to
>> > +         rely on one refer to the permissively licensed firmwared:
>>
>> Typo: firmware
>
> Thanks fixed all typos except this one, this one is meant to be firmwared as
> that is the name of the project, the url is below.
>
>>
>> > +
>> > +         https://github.com/teg/firmwared

Oh! Yes, hah. :) Thanks!

-Kees

-- 
Kees Cook
Pixel Security
