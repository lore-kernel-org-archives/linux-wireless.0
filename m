Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59238 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752323AbdHBJVU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Aug 2017 05:21:20 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Souptick Joarder <jrdr.linux@gmail.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4] rtlwifi: Replace hardcode value with macro
References: <20170731111445.GA4844@symbol-HP-ZBook-15>
        <8af42486-dd0b-bda6-6125-148dc0011115@lwfinger.net>
Date: Wed, 02 Aug 2017 12:21:15 +0300
In-Reply-To: <8af42486-dd0b-bda6-6125-148dc0011115@lwfinger.net> (Larry
        Finger's message of "Mon, 31 Jul 2017 09:18:51 -0500")
Message-ID: <87vam6496c.fsf@codeaurora.org> (sfid-20170802_112123_254137_94FD178E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> On 07/31/2017 06:14 AM, Souptick Joarder wrote:
>> In _rtl_init_mac80211(), hardcoded value for hw->max_listen_interval
>> and hw->max_rate_tries are replaced by macro.
>
> That is NOT what your patch does. It only removes a comment! Granted,
> that comment is useless and should come out, but your commit message
> must be a little more accurate.

Actually the patch does not even apply, I suspect that Souptick
incorrectly used v3 of his patch as the baseline for v4. Instead this v4
should be folded with v3.

-- 
Kalle Valo
