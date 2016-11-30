Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45328 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752167AbcK3KQm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Nov 2016 05:16:42 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Jes.Sorensen@redhat.com
Cc: linux-wireless@vger.kernel.org, briselec@gmail.com
Subject: Re: [PATCH 0/1] rtl8xxxu: Workaround for 8192eu/8723bu not reconnecting
References: <20161129235902.11882-1-Jes.Sorensen@redhat.com>
Date: Wed, 30 Nov 2016 10:46:42 +0200
In-Reply-To: <20161129235902.11882-1-Jes.Sorensen@redhat.com> (Jes Sorensen's
        message of "Tue, 29 Nov 2016 18:59:01 -0500")
Message-ID: <87mvghtkwd.fsf@kamboji.qca.qualcomm.com> (sfid-20161130_111655_699317_6CAC240A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jes.Sorensen@redhat.com writes:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>
> Hi,
>
> This patch works around the issue with 8192eu and 8723bu devices not
> being able to reconnect. It is still not clear why this fails, and
> looking at rtlwifi it does issue the command for 8192ee and 8723be
> devices.
>
> Until we have a better idea of what is going on, I have commented out
> the offending code. I prefer not deleting it until we have a better
> understanding of why this is causing issues.
>
> Credits to Barry Day for tracking down and isolating the issue.
>
> Kalle, not sure if this can make it to 4.9, but if it's possible it
> would be ideal since this is causing real issues in the field.

For 4.9 this is too late, sorry. I'll queue this to 4.10.

-- 
Kalle Valo
