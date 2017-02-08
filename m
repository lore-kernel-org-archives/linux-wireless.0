Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54558 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751412AbdBHTfi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 14:35:38 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>
Subject: Re: pull-request: iwlwifi-next 2017-02-08
References: <1486580477.10952.14.camel@coelho.fi>
Date: Wed, 08 Feb 2017 21:35:07 +0200
In-Reply-To: <1486580477.10952.14.camel@coelho.fi> (Luca Coelho's message of
        "Wed, 08 Feb 2017 21:01:17 +0200")
Message-ID: <878tpglbmc.fsf@kamboji.qca.qualcomm.com> (sfid-20170208_203552_345487_89525F50)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> Here's my third and final pull-request intended for v4.11.  As I
> mentioned before, I concentrated on our bugfix patches this time.  More
> details in the tag description.
>
> I have sent this out before, but I didn't get kbuildbot results yet. 
> Hopefully there will be no issues.  I'm sending it out already because
> you asked me to send this before 9pm today (I'm probably 1 or 2 minutes
> late :P).  It's up to you whether you want to pull it as is or wait for
> kbuildbot results.
>
> Please let me know if there are any issues.
>
> Cheers,
> Luca.
>
>
> The following changes since commit 8364fbb497f00de21d6d347194fa8b6bbae1d6f5:
>
>   iwlwifi: mvm: support new beacon template command (2017-02-06 19:19:27 +0200)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git tags/iwlwifi-next-for-kalle-2017-02-08
>
> for you to fetch changes up to 0c8d0a4770cb6863f78a25c8d211f42e9c82251c:
>
>   iwlwifi: mvm: avoid exceeding the allowed print length (2017-02-08 17:54:23 +0200)
>
> ----------------------------------------------------------------
> Some patches focusing on bugfixes for v4.11:
>
>   * Fix 802.11w, which was failing to due an IGTK bug;
>   * A few more bugzilla bug fixes;
>   * A channel-switch race condition fix;
>   * Some fixes related to suspend/resume with new HW;
>   * The RF-kill saga continues;
>   * And some other fixes here and there...
>
> ----------------------------------------------------------------

Pulled, thanks.

-- 
Kalle Valo
