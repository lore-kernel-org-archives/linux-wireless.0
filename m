Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:48509 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab2BMLTy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 06:19:54 -0500
Received: by vcge1 with SMTP id e1so3022031vcg.19
        for <linux-wireless@vger.kernel.org>; Mon, 13 Feb 2012 03:19:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAO1ZyK=NRx2WD_B6=zikpTvX+Z+2F3t_sVU2Hrc3DeaZPMUwNw@mail.gmail.com>
References: <CAO1ZyK=NRx2WD_B6=zikpTvX+Z+2F3t_sVU2Hrc3DeaZPMUwNw@mail.gmail.com>
Date: Mon, 13 Feb 2012 16:49:53 +0530
Message-ID: <CAD2nsn0gLz_F-M1r6zKOsZPzjiP0C+RDCPaV+hmv0UVnJgvnPg@mail.gmail.com> (sfid-20120213_121957_798273_610F6EF7)
Subject: Re: How to debug the linux wireless driver
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Claudio Rossi <rossi.claudio.82@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 11, 2012 at 3:16 AM, Claudio Rossi
<rossi.claudio.82@gmail.com> wrote:
> Dear all,
>  I have started to modify the linux wireless (mac80211) in order to
> had some MAC layer statistics. I am using compat-wireless-3.2-rc6-3
> and this is my first kernel programming experience. I do not know how
> to face programming errors without corrupting a kernel version, e.g.,
> due to my modification to the code, in this moment I get a black
> screen with  kernel 2.6.32-37-generic. I have now booted with
> 2.6.32-38-generic: how  can I restore the previous version of the
> modules in the kernel 2.6.37-generic?

*may be you can try to switch off your  wifi with the help of rfkill
switch, boot your machine and install a new compat wireless

*or boot with 2.6.32-38-generic and remove mac80211.ko (or) your driver files in
/lib/modules/2.6.32-37../updates/net/mac80211


>
> Moreover, is there any way to do a sort of debug ?
>
> Thank you
>
> --
> Claudio Rossi
> -------------------
> Office @ PoliTO: +39 011 5644194
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
shafi
