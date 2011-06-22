Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from msr12.hinet.net ([168.95.4.112]:57293 "EHLO msr12.hinet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757816Ab1FVClA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 22:41:00 -0400
Date: Wed, 22 Jun 2011 10:39:23 +0800
From: Ali Bahar <ali@internetdog.org>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: r8712u driver for the rtl8192su chip.
Message-ID: <20110622023923.GA12547@internetdog.org> (sfid-20110622_044104_526429_FA126582)
Reply-To: ali@internetdog.org
References: <776913.88107.qm@web161609.mail.bf1.yahoo.com>
 <4DC0312A.4040303@lwfinger.net>
 <BANLkTinw+jv8zBi29EKs2K2=tAJMYCEdgQ@mail.gmail.com>
 <4DC0669E.4040100@lwfinger.net>
 <BANLkTikxS_2wJEpijmYQy3nPy2-9pykxdA@mail.gmail.com>
 <4DC06BF3.6070208@lwfinger.net>
 <20110621124954.GA8462@internetdog.org>
 <4E011644.3070906@lwfinger.net>
 <20110622010057.GA12123@internetdog.org>
 <BANLkTinD=zRLioxjruqPCMa1hkG4nUxBEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <BANLkTinD=zRLioxjruqPCMa1hkG4nUxBEw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Julian,

On Wed, Jun 22, 2011 at 12:03:26PM +1000, Julian Calaby wrote:

> >> >root@hashbang Tue Jun 21 18:30:06 ~$ iwconfig wlan2 essid "h55m"
> >> >Error for wireless request "Set ESSID" (8B1A) :
> >> >     SET failed on device wlan2 ; Operation not permitted.
> >> >root@hashbang Tue Jun 21 18:30:47 ~$ uname -r
> >
> > How is root unprivileged? The shell-prompt shows the user.
> 
> In general, root prompts have a '#' at the end of the prompt, this one
> has a '$' which is indicative of a non-privileged user.

This box sets it differently. I understand how it could be missed in
my post.

Thanks,
ali
