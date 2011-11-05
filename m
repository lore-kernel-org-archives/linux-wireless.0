Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48880 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab1KEUEn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Nov 2011 16:04:43 -0400
Received: by iage36 with SMTP id e36so4045274iag.19
        for <linux-wireless@vger.kernel.org>; Sat, 05 Nov 2011 13:04:43 -0700 (PDT)
Message-ID: <4EB596D8.7030600@lwfinger.net> (sfid-20111105_210501_372255_5AEE584F)
Date: Sat, 05 Nov 2011 15:04:40 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Andres Cimmarusti <acimmarusti@gmail.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: realtek driver version in kernel
References: <CAH=dYrEbZ4woz8O6XoKwoRU2xENXmbzDjbvmWu76mA9MKJ0COw@mail.gmail.com>
In-Reply-To: <CAH=dYrEbZ4woz8O6XoKwoRU2xENXmbzDjbvmWu76mA9MKJ0COw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/05/2011 11:43 AM, Andres Cimmarusti wrote:
> Dear Mr. Finger,
>
> I apologize for the audacity of contacting you directly. I saw your
> name and email on one of the source files for the realtek wireless
> drivers.
> I have a question about the Realtek wireless driver (specifically
> rtl8192se) version included in kernels 3.0.x and 3.1.x.
>
> If I go to Realtek's website they mention a driver version:
> rtl_92ce_92se_92de_linux_mac80211_0004.0816.2011
>
> Is this included in kernel 3.0.x? or should I upgrade to 3.1?
>
> I've been having a lot of disconnection and reconnection issues with
> certain networks using a RTL8191SEvB (which loads the rtl8192se driver
> module). I don't know for sure what the problem is, but I've noticed
> that in areas (like university campuses) where there might be repeated
> access points for the same network with varying signal strengths, my
> connection is rather unstable and it keeps disconnecting and
> reconnecting (I suspect there is a problem reporting the signal
> strength to NetworkManager, which causes NM to get confused as to
> which network has stronger signal...I mean in NM 0.8.4 all networks
> listed show the same number of "bars"!). Since the rtl8192se is a
> relatively new driver in the kernel, I was hoping getting the newest
> version would help solve this issue.
>
> If you have any info regarding this issue I would appreciate it very
> much. I've seen some posts online that blame it on NM...I will try to
> peruse through their bugs and see...

Note that I only do private consulting for a fee. You should send everything 
through the wireless ML, which I have added to this reply.

The newest version, i.e. 3.1, will have an improved driver. One with even more 
improvements will be in the bleeding-edge compat-wireless package. It is 
essentially the one for 3.2. Yes, rtl8192se is being improved regularly. All the 
improvements in the 08/16/2011 driver are in compat-wireless.

The number of "bars" in the NM applet are hardly a good measure of signal 
strength, but the driver does report a better value. I do not have an 
environment where I can test roaming.

Larry

