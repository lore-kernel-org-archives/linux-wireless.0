Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60670 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754727AbdJRFdm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Oct 2017 01:33:42 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Pkshih <pkshih@realtek.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        =?utf-8?B?6I6K5b2l5a6j?= <yhchuang@realtek.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Souptick Joarder <jrdr.linux@gmail.com>,
        "devel\@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Two rtlwifi drivers?
References: <20170824100832.lcmbwcjhzwlgozeh@mwanda>
        <87h8wxw4bq.fsf@kamboji.qca.qualcomm.com>
        <652d42ad-a077-530b-743f-d38ddf3ff677@lwfinger.net>
        <87k202qcjr.fsf@kamboji.qca.qualcomm.com>
        <20171011131310.GF32250@kroah.com>
        <87h8v4pxqp.fsf@kamboji.qca.qualcomm.com>
        <20171012103450.GA24647@kroah.com>
        <5B2DA6FDDF928F4E855344EE0A5C39D10581FF70@RTITMBSV07.realtek.com.tw>
        <87bml7mdlj.fsf@kamboji.qca.qualcomm.com>
        <5B2DA6FDDF928F4E855344EE0A5C39D105821780@RTITMBSV07.realtek.com.tw>
Date: Wed, 18 Oct 2017 08:33:37 +0300
In-Reply-To: <5B2DA6FDDF928F4E855344EE0A5C39D105821780@RTITMBSV07.realtek.com.tw>
        (pkshih@realtek.com's message of "Tue, 17 Oct 2017 01:45:45 +0000")
Message-ID: <87lgk92f66.fsf@codeaurora.org> (sfid-20171018_073346_493056_C9A81C25)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pkshih <pkshih@realtek.com> writes:

>> My recommendation is to avoid accumulating patches at all cost and start
>> submitting them as soon as you can. This way you get patches committed
>> much more smoother. So do not wait until _all_ patches are ready,
>> instead start submitting patches as soon as you have _some_ patches
>> ready. In other words, keep the delta between mainline and your
>> not-yet-submitted patches as small as possible.
>> 
>> And the patches don't need to be bug free as you can always fix bugs
>> later. Just mention in the commit logs that this is preparation for some
>> new feature and not fully tested yet. We do that all the time, for
>> example Intel's iwlwifi has support for hardware which have not reached
>> customers yet.
>> 
>
> Thanks for your answer. I'll submit patches when the drivers are ready and
> stable. I have another question about the rules of new files. If I want to
> add some new files, could I send a big patch with all new files? Is there
> any limit? 

The only limit I know is the byte size limit in the mailing list. When
submitting a new driver some people split the driver to one file per
patch for easier review but the final commit needs to be one big patch
with all files included. If you are adding big files to rtlwifi I think
you could try to follow the same model.

-- 
Kalle Valo
