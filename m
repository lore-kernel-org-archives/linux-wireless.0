Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43760 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751743AbdJPHpk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Oct 2017 03:45:40 -0400
Date: Mon, 16 Oct 2017 10:45:16 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Pkshih <pkshih@realtek.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?utf-8?B?6I6K5b2l5a6j?= <yhchuang@realtek.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Souptick Joarder <jrdr.linux@gmail.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: Two rtlwifi drivers?
Message-ID: <20171016074516.4irgvbid6p5zwqjg@mwanda> (sfid-20171016_094544_389610_43E5EACA)
References: <20170824100832.lcmbwcjhzwlgozeh@mwanda>
 <87h8wxw4bq.fsf@kamboji.qca.qualcomm.com>
 <652d42ad-a077-530b-743f-d38ddf3ff677@lwfinger.net>
 <87k202qcjr.fsf@kamboji.qca.qualcomm.com>
 <20171011131310.GF32250@kroah.com>
 <87h8v4pxqp.fsf@kamboji.qca.qualcomm.com>
 <20171012103450.GA24647@kroah.com>
 <5B2DA6FDDF928F4E855344EE0A5C39D10581FF70@RTITMBSV07.realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5B2DA6FDDF928F4E855344EE0A5C39D10581FF70@RTITMBSV07.realtek.com.tw>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 16, 2017 at 02:41:38AM +0000, Pkshih wrote:
> 2) The rtlwifi in staging
>    In staging, the module phydm v13 contains bugs, so I want to upgrade
>    to v21 (Realtek internal version number). This upgrade contains a
>    big patch that the difference between v13 and v21, and there are 
>    40+ patches to support this upgrade. I have three options, and
>    I want to know which one is prefer.

We can't discuss patches we haven't seend.  Please just send them right
away without any delay to both lists, and we can decide from there.

40 patches is a medium size set, patch that we are used to dealing with
every day.

regards,
dan carpenter
