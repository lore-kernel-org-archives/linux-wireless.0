Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42116 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751964AbdJPNWx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Oct 2017 09:22:53 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Pkshih <pkshih@realtek.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        =?utf-8?B?6I6K5b2l5a6j?= <yhchuang@realtek.com>,
        Johannes Berg <johannes.berg@intel.com>,
        "Souptick Joarder" <jrdr.linux@gmail.com>,
        "devel\@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kernel-janitors\@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: Two rtlwifi drivers?
References: <20170824100832.lcmbwcjhzwlgozeh@mwanda>
        <87h8wxw4bq.fsf@kamboji.qca.qualcomm.com>
        <652d42ad-a077-530b-743f-d38ddf3ff677@lwfinger.net>
        <87k202qcjr.fsf@kamboji.qca.qualcomm.com>
        <20171011131310.GF32250@kroah.com>
        <87h8v4pxqp.fsf@kamboji.qca.qualcomm.com>
        <20171012103450.GA24647@kroah.com>
        <5B2DA6FDDF928F4E855344EE0A5C39D10581FF70@RTITMBSV07.realtek.com.tw>
Date: Mon, 16 Oct 2017 16:22:48 +0300
In-Reply-To: <5B2DA6FDDF928F4E855344EE0A5C39D10581FF70@RTITMBSV07.realtek.com.tw>
        (pkshih@realtek.com's message of "Mon, 16 Oct 2017 02:41:38 +0000")
Message-ID: <87bml7mdlj.fsf@kamboji.qca.qualcomm.com> (sfid-20171016_152257_092000_4319BACC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi PK,

you got good answers already so only short reply from me:

Pkshih <pkshih@realtek.com> writes:

> 3) Coming drivers -- rtl8723de and rtl8821ce
>    We're developing the two drivers, and rtl8723de and rtl8821ce will
>    be ready on 2017Q4 and 2018Q1 respectively. The drivers are based on
>    rtl8822be that in staging now, so the line of code will be fewer.
>    The new files will be a new IC folder and IC supported files of 
>    three modules that btcoexist, phydm and halmac. Could I submit
>    them to wirless tree when they're ready?

My recommendation is to avoid accumulating patches at all cost and start
submitting them as soon as you can. This way you get patches committed
much more smoother. So do not wait until _all_ patches are ready,
instead start submitting patches as soon as you have _some_ patches
ready. In other words, keep the delta between mainline and your
not-yet-submitted patches as small as possible.

And the patches don't need to be bug free as you can always fix bugs
later. Just mention in the commit logs that this is preparation for some
new feature and not fully tested yet. We do that all the time, for
example Intel's iwlwifi has support for hardware which have not reached
customers yet.

> On the way, I'll attend netdev workshop in Korea, so we can meet there
> if you attend too.

I'm also attending Netdev 2.2, looking forward to meeting you there.

-- 
Kalle Valo
