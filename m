Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57966 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754037AbdBHOaz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 09:30:55 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH 00/17] iwlwifi: updates intended for v4.11 2017-02-08
References: <20170208112322.29413-1-luca@coelho.fi>
Date: Wed, 08 Feb 2017 16:29:47 +0200
In-Reply-To: <20170208112322.29413-1-luca@coelho.fi> (Luca Coelho's message of
        "Wed, 8 Feb 2017 13:23:05 +0200")
Message-ID: <87vaskn4bo.fsf@kamboji.qca.qualcomm.com> (sfid-20170208_153110_999172_298BF143)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> This is the third and final pull-request before 4.11's merge window.
> This time I concentrated in bugfixes:
>
> * Fix 802.11w, which was failing to due an IGTK bug;
> * A few more bugzilla bug fixes;
> * A channel-switch race condition fix;
> * Some fixes related to suspend/resume with new HW;
> * The RF-kill saga continues;
> * And some other fixes here and there...
>
> As usual, I'm pushing this to a pending branch, for kbuild bot, and
> will send a pull-request later.
>
> Please review.

I only see patches 1-8 in the mailing list or in my inbox, what happened
to the rest?

-- 
Kalle Valo
