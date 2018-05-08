Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:46425 "EHLO
        mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933079AbeEHWpE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 May 2018 18:45:04 -0400
Received: by mail-vk0-f67.google.com with SMTP id i190-v6so20672357vkd.13
        for <linux-wireless@vger.kernel.org>; Tue, 08 May 2018 15:45:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180508181247.19431-1-mcgrof@kernel.org>
References: <20180508181247.19431-1-mcgrof@kernel.org>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 8 May 2018 15:45:02 -0700
Message-ID: <CAGXu5jJ=9XKn=z1T16iV-BoN88QLh7q+OicZxc5TvEjioriGMA@mail.gmail.com> (sfid-20180509_004520_890450_BF6E443A)
Subject: Re: [PATCH v6 00/13] firmware_loader changes for v4.18
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>, maco@android.com,
        Andy Gross <andy.gross@linaro.org>,
        David Brown <david.brown@linaro.org>,
        bjorn.andersson@linaro.org, teg@jklm.no, wagi@monom.org,
        Hans de Goede <hdegoede@redhat.com>,
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

On Tue, May 8, 2018 at 11:12 AM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> Greg,
>
> Here is what I have queued up for the firmware_loader for v4.18. It
> includes a slew of cleanup work, and the new firmware_request_nowarn()
> which is quiet but enables the sysfs fallback mechanism. I've gone ahead
> and also queued up a few minor fixes for the firmware loader documentation
> which have come up recently. These changes are available on my git tree
> both based on linux-next [0] and Linus' latest tree [1]. Folks working
> on new developments for the firmware loader can use my linux-next
> branch 20180508-firmware_loader_for-v4.18-try2 for now.
>
> 0-day sends its blessings.
>
> The patches from Mimi's series still require a bit more discussion and
> review. The discussion over the EFI firmware fallback mechanism is still
> ongoing.
>
> As for the rename that you wanted, perhaps we can do this late in the
> merge window considering we're at rc4 now. I can prep something up for
> that later.
>
> Question, and specially rants are warmly welcomed.

I sent some typo catches, but with those fixed, please consider the
whole series:

Reviewed-by: Kees Cook <keescook@chromium.org>

Thanks!

-Kees

-- 
Kees Cook
Pixel Security
