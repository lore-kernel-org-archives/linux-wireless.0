Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:40361 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbZCSVjX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2009 17:39:23 -0400
Received: by fg-out-1718.google.com with SMTP id e12so113846fga.17
        for <linux-wireless@vger.kernel.org>; Thu, 19 Mar 2009 14:39:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49C12DFA.80308@giuppi.com>
References: <49C12DFA.80308@giuppi.com>
Date: Thu, 19 Mar 2009 21:39:20 +0000
Message-ID: <3ace41890903191439q1c375925md2e4227f79147399@mail.gmail.com> (sfid-20090319_223925_593162_C9D21F0E)
Subject: Re: rtl8187 bug report
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: "Info[at]Giuppi" <info@giuppi.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 18, 2009 at 5:23 PM, Info[at]Giuppi <info@giuppi.com> wrote=
:
> I have a rtl8187B usb dongle, works pretty well with new driver rtl81=
87.
> Thanks for the great job you're doing.
>
> The problem comes when I try to handle my WEP protected network in
> monitor mode.
> It becomes really slow in finding/showing the network and when it
> appears in the list, no activity
> is detected. I mean beacons or data remains at 0 in the airodump-ng
> screen (from latest svn aircrack-ng suite)
>
> Everything works fine in managed mode and the network is easily detec=
ted
> and i can connect too.
>
> I also have a rt73usb device and this one works as expected.
>
> I'm currently using ubuntu-backport modules but I've also tryed the
> compat-wireless package dated 17 march
> kernel version 2.6.27-13-generic
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wirel=
ess" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

I am not familiar with aircrack-ng, but I believe it can be used with
a modified version of the vendor rtl8187 driver, (and the aircrack-ng
people hosts a modified version of the vendor driver on their web
site). I have not actually looked at their modification so I have no
idea what modification is required for aircrack-ng to work well, but I
believe *some* adaptation is required?

On a different issue - I think such adaptation are frown upon and will
not make it into the standard kernel, due to its nature of typical
usage in a controversal scenario. Maybe other wireless dev people,
especially Herton and Larry, can advise.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
