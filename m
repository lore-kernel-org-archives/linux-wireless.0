Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43678 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751479AbdJLH7r (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Oct 2017 03:59:47 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Cathy Luo" <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Karthik Doddayennegere Ananthapadmanabha <karthida@marvell.com>,
        Brian Norris <briannorris@chromium.org>
Subject: Re: [EXT] Re: [PATCH] mwifiex: Random MAC address during scanning
References: <1506682390-27716-1-git-send-email-gbhat@marvell.com>
        <20171011194148.GA84547@google.com>
        <e38c11f1b81f4b23911f4bd7a3fdc718@SC-EXCH02.marvell.com>
Date: Thu, 12 Oct 2017 10:59:41 +0300
In-Reply-To: <e38c11f1b81f4b23911f4bd7a3fdc718@SC-EXCH02.marvell.com>
        (Ganapathi Bhat's message of "Thu, 12 Oct 2017 05:53:47 +0000")
Message-ID: <87lgkgpziq.fsf@kamboji.qca.qualcomm.com> (sfid-20171012_100051_679771_AFBA446C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ganapathi Bhat <gbhat@marvell.com> writes:

> Hi Kalle,
>>
>> > ----------------------------------------------------------------------
>> > On Fri, Sep 29, 2017 at 04:23:10PM +0530, Ganapathi Bhat wrote:
>> > > From: Karthik Ananthapadmanabha <karthida@marvell.com>
>> > >
>> > > Driver will advertise RANDOM_MAC support only if the device supports
>> > > this feature.
>> > >
>> > > Signed-off-by: Karthik Ananthapadmanabha <karthida@marvell.com>
>> > > Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
>> >
>> > I'd just like to point out that this is a very bad commit subject:
>> >
>> > "[PATCH] mwifiex: Random MAC address during scanning"
>> >
>> > It's borderline wrong, really. "Random MAC address during scanning" is
>> > already supported. This patch is just adding a feature-flag check for
>> > it, since some firmwares in the wild don't support it. A more accurate
>> > description would be something like:
>> >
>> > "[PATCH] mwifiex: Add feature flag support for MAC randomization"
>> >
>> > The patch is already applied, so I'd only worry about it for future
>> > submissions (no need to resend).

Brian, thanks for pointing out that. I had missed it.

>> I'm Really Sorry.  I will take care of this in future.
>>
> The firmware which advertises this capability flag is yet to be shared
> in upstream. The latest available firmware does not contain this flag.
> So, is it possible to revert this change, so that we will resubmit
> this (with proper subject) once our firmware is uploaded.

Like Brian said, I don't think there's any point reverting it and
resending the patch. Just something to learn for the future, for both of
us. (I need to also check the titles more carefully.)

-- 
Kalle Valo
