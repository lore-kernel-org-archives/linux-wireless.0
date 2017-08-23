Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46602 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932090AbdHWPV4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Aug 2017 11:21:56 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: pull-request: iwlwifi-next 2017-08-18
References: <1503132116.15969.327.camel@coelho.fi>
Date: Wed, 23 Aug 2017 18:21:51 +0300
In-Reply-To: <1503132116.15969.327.camel@coelho.fi> (Luca Coelho's message of
        "Sat, 19 Aug 2017 11:41:56 +0300")
Message-ID: <87pobmwbqo.fsf@kamboji.qca.qualcomm.com> (sfid-20170823_172200_000721_544FBEDA)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> Here's my third pull-request intended for v4.14.=C2=A0 We continued doing
> generic development work, with improvements, bug fixes and=C2=A0cleanups =
all
> around.=C2=A0 More=C2=A0details in the tag description.
>
> My patch "iwlwifi: update channel flags parser" is going to cause a
> conflict with net because they both change the same string in debug
> message.  Emmanuel's patch "iwlwifi: split the regulatory rules when the
> bandwidth flags require it" added "reg_flags" to the string and changed
> the Ad-hoc string.  My patch added a few %s's and also changed the Ad-
> hoc string.  The result of the conflict resolution should look like
> this:
>
> "Ch. %d [%sGHz] %s%s%s%s%s%s%s%s%s%s%s%s(0x%02x) reg_flags 0x%x: %s\n"

Thanks, I'll Cc Stephen because he most probably sees that conflict
tomorrow.

> I have sent this out before, and kbuildbot reported success.
>
> Please let me know if there are any issues.
>
> Cheers,
> Luca.
>
>
> The following changes since commit 38ef62353acbaa0eea062a9f047b33aebd7d52=
ce:
>
>   rsi: security enhancements for AP mode (2017-08-17 10:07:00 +0300)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git =
tags/iwlwifi-next-for-kalle-2017-08-18
>
> for you to fetch changes up to 8fe34b060a4b11be35ffd9383acdd0bc7bee72e2:
>
>   iwlwifi: use big-endian for the hw section of the nvm (2017-08-18 17:36=
:42 +0300)
>
> ----------------------------------------------------------------
> Third set of iwlwifi patches for 4.14
>
> * Work for the upcoming A000 device family continues;
> * Improvements in debugging;
> * A couple of improvements in block-ack sessions;
> * Some fixes for channel switch;
> * A workaround for a HW data bug;
> * Some FW API updates;
> * General fixes and cleanups here and there.
>
> ----------------------------------------------------------------

Pulled, thanks.

--=20
Kalle Valo
