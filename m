Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37982 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935279AbeEIUzt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 16:55:49 -0400
Date: Wed, 9 May 2018 20:55:44 +0000
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
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
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
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
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        tkjos@android.com, Jonathan Corbet <corbet@lwn.net>,
        mchehab+samsung@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-scsi@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH v6 05/13] firmware_loader: enhance Kconfig documentation
 over FW_LOADER
Message-ID: <20180509205544.GW27853@wotan.suse.de> (sfid-20180509_225639_124741_88DA0133)
References: <20180508181247.19431-1-mcgrof@kernel.org>
 <20180508181247.19431-6-mcgrof@kernel.org>
 <CAGXu5jJXMxx2Xna_M_g1wsS59XnYKqHAGdxhzDtk3PhnLL-gQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGXu5jJXMxx2Xna_M_g1wsS59XnYKqHAGdxhzDtk3PhnLL-gQQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 08, 2018 at 03:42:33PM -0700, Kees Cook wrote:
> On Tue, May 8, 2018 at 11:12 AM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> > +         This used to be the default firmware loading facility, and udev used
> > +         to listen for uvents to load firmware for the kernel. The firmware
> > +         loading facility functionality in udev has been removed, as such it
> > +         can no longer be relied upon as a fallback mechanism. Linux no longer
> > +         relies on or uses a fallback mechanism in userspace. If you need to
> > +         rely on one refer to the permissively licensed firmwared:
> 
> Typo: firmware

Thanks fixed all typos except this one, this one is meant to be firmwared as
that is the name of the project, the url is below.

> 
> > +
> > +         https://github.com/teg/firmwared

  Luis
