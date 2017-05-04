Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47252 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751391AbdEDNLt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 May 2017 09:11:49 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Brian Norris <briannorris@chromium.org>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rajat Jain <rajatja@google.com>
Subject: Re: [4/4] mwifiex: pcie: de-duplicate buffer allocation code
References: <20170311013924.73348-5-briannorris@chromium.org>
        <20170320170835.5ED1C609C6@smtp.codeaurora.org>
        <20170320200550.GA12143@google.com>
        <874lym7roy.fsf@kamboji.qca.qualcomm.com>
        <20170428165046.GA98398@google.com>
Date: Thu, 04 May 2017 16:11:41 +0300
In-Reply-To: <20170428165046.GA98398@google.com> (Brian Norris's message of
        "Fri, 28 Apr 2017 09:50:48 -0700")
Message-ID: <87k25wrcky.fsf@kamboji.qca.qualcomm.com> (sfid-20170504_151225_700671_CB69EBBB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brian Norris <briannorris@chromium.org> writes:

> On Tue, Mar 21, 2017 at 02:14:05PM +0200, Kalle Valo wrote:
>> What I could do is to wait for the patches 1-3 trickle down to w-d-next
>> and then apply this patch. It usually takes few weeks, but with bad luck
>> it might happen only after the merge window. Would that work?
>
> Is this going to get picked up?

Oh man, I thought I had changed the state of this patch from Changes
Requested to Awaiting Upstream but apparently I didn't do that and hence
missed the patch. It's now back in active my queue in Under Review
state:

https://patchwork.kernel.org/patch/9618309/

Thanks for reminding me and sorry for the screwup.

-- 
Kalle Valo
