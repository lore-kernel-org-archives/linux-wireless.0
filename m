Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:41034 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbaFLTWh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2014 15:22:37 -0400
Received: by mail-ob0-f172.google.com with SMTP id uy5so1802918obc.3
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jun 2014 12:22:36 -0700 (PDT)
Message-ID: <5399FDFA.9000203@lwfinger.net> (sfid-20140612_212240_564131_A61D2530)
Date: Thu, 12 Jun 2014 14:22:34 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Matt Chen <mattsled@gmail.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
CC: Helmut Schaa <helmut.schaa@googlemail.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: Re: Driver for Mediatek MT7630E
References: <53987997.2040101@lwfinger.net>	<CAGXE3d81xMB3Y4WdTBPHKCC91QaieAQd5xzAqWSgGeonbD7_vw@mail.gmail.com>	<20140612124408.GB7325@redhat.com> <CALx5=V8rMz+HKE=1frLJRqCqqGMP3QPX1yJ-T+GA2dXDnohZ0g@mail.gmail.com>
In-Reply-To: <CALx5=V8rMz+HKE=1frLJRqCqqGMP3QPX1yJ-T+GA2dXDnohZ0g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/12/2014 11:33 AM, Matt Chen wrote:
> If I remember correct for SLE11, that was from MediaTek-Ralink, they
> did it based on SLE11 kernel. The code is ouch but could work. That
> was a nightmare when I tried to port...can't imagine that.... :(

I have not tested as my hardware has not been delivered, but I have the driver 
building with current wireless-testing source. I also have created a proper 
Makefile.

Yes, merging the changes into rt2x00 will be a hassle.

Larry



