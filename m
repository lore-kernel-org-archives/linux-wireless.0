Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56682 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937883AbdDTIEL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Apr 2017 04:04:11 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>
Subject: Re: pull-request: iwlwifi-next 2017-04-19-2
References: <1492664371.31741.91.camel@coelho.fi>
Date: Thu, 20 Apr 2017 11:04:05 +0300
In-Reply-To: <1492664371.31741.91.camel@coelho.fi> (Luca Coelho's message of
        "Thu, 20 Apr 2017 07:59:31 +0300")
Message-ID: <87o9vr5wui.fsf@kamboji.qca.qualcomm.com> (sfid-20170420_100422_692780_E867B49D)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> Here's v2 of=C2=A0my second pull-request intended for v4.12.  It includes=
 the
> last three patch series I sent out, namely 2017-04-13, 2017-04-19 and
> the 2 fixes by Johannes that I sent a few minutes ago.
>
> I also removed the "bump API to 31" patch.  I'll send a diff=C2=A0between
> this tag and the HEAD of the patches I sent in the 2017-04-19 series.
>
> Please let me know if there are any issues.
>
> Cheers,
> Luca.
>
>
> The following changes since commit 26ecfe01790381c4caa65ec9cce484c623f092=
c4:
>
>   brcmfmac: only build fwsignal module for CONFIG_BRCMFMAC_PROTO_BCDC (20=
17-04-19 14:39:44 +0300)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git =
tags/iwlwifi-next-for-kalle-2017-04-19-2
>
> for you to fetch changes up to 718ceb22a0ccd0b3a02a4bd401d944a1eb16f3ce:
>
>   iwlwifi: pcie: free context info in case of failures (2017-04-20 07:28:=
03 +0300)
>
> ----------------------------------------------------------------
> Another series of patches intended for v4.12.  These are the changes:
>
>  * Heavy work for the A000 device series;
>  * Some cleanup patches;
>  * A few fixes;
>  * Dynamic SAR support;
>  * Geographical SAR support;
>  * Support a few new PCI device IDs;
>
> ----------------------------------------------------------------

Pulled, thanks.

--=20
Kalle Valo
