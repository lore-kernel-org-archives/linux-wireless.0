Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:55532 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbaDPCSs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2014 22:18:48 -0400
Received: by mail-lb0-f175.google.com with SMTP id w7so7619760lbi.34
        for <linux-wireless@vger.kernel.org>; Tue, 15 Apr 2014 19:18:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <533EDA4E.9020308@gmail.com>
References: <533EDA4E.9020308@gmail.com>
Date: Wed, 16 Apr 2014 07:48:46 +0530
Message-ID: <CAG+h2qhpYYCeCJujURwgzt87MrLS2x=daeS0Ac+5p3jV_gWZTw@mail.gmail.com> (sfid-20140416_041852_254660_F250D78C)
Subject: Re: Fwd: Submission of firmware for driver RSI
From: Fariya <fariyaf@gmail.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I submitted the RSI 91x firmware [around 2 weeks back] for inclusion
in the git linux-firmware repo to Ben Hutchings, as well as emailed it
to the linux-wireless mailing list. However, I have so far not got any
confirmation of it being included in the linux-firmware repo. Now that
the RSI 91x driver is part of the latest kernel, I would of course
want the firmware to be in, as well. Can someone suggest how do I go
about this/know the status of this?

Regards,
Fariya


On Fri, Apr 4, 2014 at 9:44 PM, Xose Vazquez Perez
<xose.vazquez@gmail.com> wrote:
> Fariya wrote:
>
>> I would like to submit the RSI firmware to the linux-firmware git. Can
>> anyone point me to the procedure for f/w submission? Can I submit the
>> f/w onto this mailing list?
>
> https://git.kernel.org/cgit/linux/kernel/git/firmware/linux-firmware.git/plain/README
> is your friend:
>
> --cut--
>
>         Linux firmware
>         ==============
>
>   <http://git.kernel.org/?p=linux/kernel/git/firmware/linux-firmware.git>
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
>
> This repository contains all these firmware images which have been
> extracted from older drivers, as well various new firmware images which
> we were never permitted to include in a GPL'd work, but which we _have_
> been permitted to redistribute under separate cover.
>
> To submit firmware to this repository, please send either a git binary
> diff or preferably a git pull request to:
>       David Woodhouse <dwmw2@infradead.org>
>       Ben Hutchings <ben@decadent.org.uk>
> and also cc: to related mailing lists.
>
> Your commit should include an update to the WHENCE file clearly
> identifying the licence under which the firmware is available, and
> that it is redistributable. If the licence is long and involved, it's
> permitted to include it in a separate file and refer to it from the
> WHENCE file.
> And if it were possible, a changelog of the firmware itself.
>
> Ideally, your commit should contain a Signed-Off-By: from someone
> authoritative on the licensing of the firmware in question (i.e. from
> within the company that owns the code).
>
>
> WARNING:
> =======
>
> Don't send any "CONFIDENTIALITY STATEMENT" in your e-mail, patch or
> request. Otherwise your firmware _will never be accepted_.
>
> Maintainers are really busy, so don't expect a prompt reply.
> --theend--



-- 
-Fariya Fatima
