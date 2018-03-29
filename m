Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40966 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750707AbeC2Igk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Mar 2018 04:36:40 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, janet.morgan@intel.com, joe.konno@intel.com
Subject: Re: pull-request: iwlwifi-next 2018-03-28
References: <1522267371.3786.294.camel@coelho.fi>
Date: Thu, 29 Mar 2018 11:36:35 +0300
In-Reply-To: <1522267371.3786.294.camel@coelho.fi> (Luca Coelho's message of
        "Wed, 28 Mar 2018 23:02:51 +0300")
Message-ID: <87fu4jl1m4.fsf@kamboji.qca.qualcomm.com> (sfid-20180329_103643_208556_FA8A1581)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> This is a batch of patches intended for v4.17.  Nothing major here,
> just the usual continued development, bugfixes, new FW APIs and some
> minor features.  More details about the contents in the tag
> description.
>
> The commit messages you commented on have been fixed, as you can see in
> v2 of those patches that I sent to the list.
>
> I have sent this out before and kbuildbot reported success.
>
> Please let me know if there are any issues.
>
> Cheers,
> Luca.
>
>
> The following changes since commit 6b7d5c0745905b71127d0c1ae6eeddc09bbdaad8:
>
>   Merge git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git (2018-03-28 11:57:34 +0300)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git tags/iwlwifi-next-for-kalle-2018-03-28
>
> for you to fetch changes up to 378c8931342f99c5a6fce21e38ef46ac39395464:
>
>   iwlwifi: wrt: add fw force restart via triggers (2018-03-28 22:43:40 +0300)
>
> ----------------------------------------------------------------
> iwlwifi patches for 4.14
>
> * Fix a UBSAN warning;
> * Improvement in the net-stack/driver log syncing
> * An RCU lock fix in the new rate-scaling code;
> * Support for new PCI IDs for the 9000 family;
> * Support for a new API version;
> * Initial work for supporting the new ETSI rules;
> * Support for advanced dwell in scanning;
> * Support for OCE in scanning;
> * Some debugging improvements;
> * Other small improvements and cleanups here and there.
>
> ----------------------------------------------------------------

Pulled, thanks.

-- 
Kalle Valo
