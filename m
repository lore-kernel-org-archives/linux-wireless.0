Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8708 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172AbaFMN12 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2014 09:27:28 -0400
Date: Fri, 13 Jun 2014 15:25:45 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Matt Chen <mattsled@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: Re: Driver for Mediatek MT7630E
Message-ID: <20140613132545.GD2211@redhat.com> (sfid-20140613_152738_565264_8F52A338)
References: <53987997.2040101@lwfinger.net>
 <CAGXE3d81xMB3Y4WdTBPHKCC91QaieAQd5xzAqWSgGeonbD7_vw@mail.gmail.com>
 <20140612124408.GB7325@redhat.com>
 <CALx5=V8rMz+HKE=1frLJRqCqqGMP3QPX1yJ-T+GA2dXDnohZ0g@mail.gmail.com>
 <5399FDFA.9000203@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5399FDFA.9000203@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 12, 2014 at 02:22:34PM -0500, Larry Finger wrote:
> On 06/12/2014 11:33 AM, Matt Chen wrote:
> >If I remember correct for SLE11, that was from MediaTek-Ralink, they
> >did it based on SLE11 kernel. The code is ouch but could work. That
> >was a nightmare when I tried to port...can't imagine that.... :(
> 
> I have not tested as my hardware has not been delivered, but I have
> the driver building with current wireless-testing source. I also
> have created a proper Makefile.
> 
> Yes, merging the changes into rt2x00 will be a hassle.

We usually we look at vendor driver and write new code to rt2x00 based
on that. For example, I did that for RT5592, Gabor for RT3593. In
oposite to cleaning up vendor driver in staging, it require lot of more
work, but also guarantee that we will have clean and maintaible code.

Stanislaw 
