Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:38814 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbYJYHIP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2008 03:08:15 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1217556fgg.17
        for <linux-wireless@vger.kernel.org>; Sat, 25 Oct 2008 00:08:13 -0700 (PDT)
Message-ID: <6bc534830810250008q526974a2w4600bb713c908688@mail.gmail.com> (sfid-20081025_090834_438753_81B07954)
Date: Sat, 25 Oct 2008 11:08:13 +0400
From: "Artem Antonov" <artem.v.antonov@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: b43: Everybody with PHY TX error, please try
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
In-Reply-To: <200810242032.04295.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200810242032.04295.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

I've tried the new firmware. There are still PHY TX errors with my BCM4318.

2008/10/24, Michael Buesch <mb@bu3sch.de>:
> Everybody with PHY TX error, please try updated firmware from
>  ftp://ftp.linksys.com/opensourcecode/wrt610n/1.00.00.018/wrt610n_v1.00.00.018_us.tgz
>  (Yeah, big tarball. It's 87MB)
>
>  Extract the file wrt610n_v1.00.00.018_us/release/src/wl/linux/wl.o out of the archive.
>  Get latest b43-tools:
>  git clone http://git.bu3sch.de/git/b43-tools.git
>
>  Build and install fwcutter from latest b43-tools.git
>
>  Extract the firmware from the wl.o file:
>  b43-fwcutter --unsupported -w /lib/firmware/DESTPATH  wl.o
>
>  Try to reproduce the PHY TX error with the new firmware.
>
>  Thanks.
>
>
>  --
>  Greetings Michael.
>  _______________________________________________
>  Bcm43xx-dev mailing list
>  Bcm43xx-dev@lists.berlios.de
>  https://lists.berlios.de/mailman/listinfo/bcm43xx-dev
>
