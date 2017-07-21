Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from coyote.holtmann.net ([212.227.132.17]:58703 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753679AbdGUKNz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Jul 2017 06:13:55 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: New Realtek driver
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <50a63e7a-045a-3386-661a-5bfe077e5b0a@lwfinger.net>
Date: Fri, 21 Jul 2017 12:13:51 +0200
Cc: Kalle Valo <kvalo@codeaurora.org>, Greg KH <gregkh@linux.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Birming Chiu <birming@realtek.com>, Pkshih <pkshih@realtek.com>
Message-Id: <617F6F88-FA7B-4BB1-8DFE-AA17D0C540DF@holtmann.org> (sfid-20170721_121359_022743_AB8CA5BA)
References: <50a63e7a-045a-3386-661a-5bfe077e5b0a@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

> Once again I find myself in the awkward position of needing to submit code to two different trees, i.e. wireless and staging.
> 
> The code in question concerns a new Realtek device, the RTL8822BE. The device is already shipping, and Realtek would like it to be available in kernel 3.14. As it consists of ~120,000 new lines of code, I have assured Realtek that 3.14 would not be possible, at least in the wireless tree. What I plan to do is submit the changes in the existing drivers through wireless, and the three totally new drivers through staging. My expectation is that this code would live for a relatively short time there, but going that route would give time for the code to be reviewed properly, but still be available in a kernel driver. All of the new code will be available in a GitHub repo maintained by Realtek for those users whose distros do not configure anything in staging.
> 
> For my part, I will push the wireless tree material as fast as I can and hope there is time available near the end of the 4.13-rcX sequence for the material to reach 4.14-rc1.

I really do not understand the need for staging if there is already active cleanup and submission to wireless-drivers happening. I find it also unfair to others who submit code to linux-wireless and have it reviewed there before it gets merged.

Also the faster it gets into wireless-drivers the faster it can be available via linux-backports. Seems many companies have used linux-backports successfully to deal with older kernel versions.

Regards

Marcel
