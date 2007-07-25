Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.236]:45380 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756364AbXGYVAw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2007 17:00:52 -0400
Received: by wx-out-0506.google.com with SMTP id h31so296298wxd
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jul 2007 14:00:51 -0700 (PDT)
Message-ID: <1ba2fa240707251400l784cbad7ja0003b24017c6535@mail.gmail.com>
Date: Thu, 26 Jul 2007 00:00:51 +0300
From: "Tomas Winkler" <tomas.winkler@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: Please pull patch-bomb for iwlwifi
Cc: "Zhu Yi" <yi.zhu@intel.com>, linux-wireless@vger.kernel.org
In-Reply-To: <20070725200721.GH7093@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <20070725085754.GA670@mail.intel.com>
	 <20070725200721.GH7093@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7/25/07, John W. Linville <linville@tuxdriver.com> wrote:
> On Wed, Jul 25, 2007 at 04:57:54PM +0800, Zhu Yi wrote:
>
> > This patch series catches wireless-dev up to the stand-alone
> > iwlwifi tree version 0.1.3.
> >
> > There are totally 117 patches so I won't post them one by one on
> > the list. Please find the commit series for the changes in the
> > patch bomb:
> >
> >     iwlwifi-efe55d8fa702a23724bf44fdd54059f8c4480941.tgz
> > at
> >     http://intellinuxwireless.org/iwlwifi/patches/
> >
> > This is based on wireless-dev commit:
> >
> >     3382ada69e6796da1675b0c5d064a472e9db2822
> >
> > Signed-off-by: Zhu Yi <yi.zhu@intel.com>
>
> I have applied these to the wireless-dev tree.  It is available now:
>
>         git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-dev.git
>
> Does the current driver (as posted) depend on mac80211 patches which
> are not upstream at this time?
>
The HT part is still not there but it can be mean wihile compiled out
in the driver. I'm suppose to submit HT  patches soon hoping for
tomorrow if everything works fine. I'm rebasing them against latest
wireless-dev.git. I will post them inline if you prefer.

I know you've asked us to review the already submitted 11n/HT patches.
I'm suggesting that we just patch over them otherwise we lost driver
stability and delay the whole process even more.  I'm not happy with
this solution myself but to bring the complete solution at once will
make us silent for another period.

> Do you believe that you have addressed the bulk of the review comments
> from the previous posting?

Most of them. The Endian issues fixing is still in progress.

Thanks
Tomas
> Thanks,
>
> John
> --
> John W. Linville
> linville@tuxdriver.com
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
