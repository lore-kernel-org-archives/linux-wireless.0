Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58942 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751154AbdHCJQl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 05:16:41 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: iwlwifi-next 2017-08-01
References: <1501582910.2588.45.camel@coelho.fi>
Date: Thu, 03 Aug 2017 12:16:35 +0300
In-Reply-To: <1501582910.2588.45.camel@coelho.fi> (Luca Coelho's message of
        "Tue, 01 Aug 2017 13:21:50 +0300")
Message-ID: <87fud9ovt8.fsf@kamboji.qca.qualcomm.com> (sfid-20170803_111644_911525_64A4E19C)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> Hi Kalle,
>
> Here's my first pull-request intended for v4.14.=C2=A0 It contain=C2=A0ge=
neric
> development work, with improvements, bug fixes and
> cleanup all around.=C2=A0 More=C2=A0details in the tag description.
>
> As I mentioned earlier today, I left Emmanuel's "iwlwifi: mvm: fix TCP
> CSUM offload with WEP and A000 series" patch out of this pull-req,
> because I'll include it in the one for 4.13.
>
> I have sent this out before, and kbuildbot reported success.
>
> Please let me know if there are any issues.
>
> Cheers,
> Luca.
>
>
> The following changes since commit d28ac7be15c70343cb270648e252f54d770eca=
6a:
>
>   rtlwifi: rtl8821ae: Fix HW_VAR_NAV_UPPER operation (2017-07-28 18:42:59=
 +0300)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git =
tags/iwlwifi-next-for-kalle-2017-08-01
>
> for you to fetch changes up to d20e30af7e65811955af5bc2a268ae75cd14e99e:
>
>   iwlwifi: mvm: don't retake the pointer to skb's CB (2017-08-01 12:41:46=
 +0300)
>
> ----------------------------------------------------------------
> First batch of iwlwifi patches for 4.14
>
> * Reorganization of the code into separate directories continues;
> * A couple of new minor features;
> * Fixes and cleanups here and there.
>
> ----------------------------------------------------------------

Pulled, thanks.

--=20
Kalle Valo
