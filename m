Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from msr8.hinet.net ([168.95.4.108]:64062 "EHLO msr8.hinet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757493Ab1FVBCc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 21:02:32 -0400
Date: Wed, 22 Jun 2011 09:00:57 +0800
From: Ali Bahar <ali@internetdog.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: r8712u driver for the rtl8192su chip.
Message-ID: <20110622010057.GA12123@internetdog.org> (sfid-20110622_030235_534889_48215316)
Reply-To: ali@internetdog.org
References: <776913.88107.qm@web161609.mail.bf1.yahoo.com>
 <4DC0312A.4040303@lwfinger.net>
 <BANLkTinw+jv8zBi29EKs2K2=tAJMYCEdgQ@mail.gmail.com>
 <4DC0669E.4040100@lwfinger.net>
 <BANLkTikxS_2wJEpijmYQy3nPy2-9pykxdA@mail.gmail.com>
 <4DC06BF3.6070208@lwfinger.net>
 <20110621124954.GA8462@internetdog.org>
 <4E011644.3070906@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4E011644.3070906@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 21, 2011 at 05:08:04PM -0500, Larry Finger wrote:
> On 06/21/2011 07:49 AM, Ali Bahar wrote:

> >this is more of a quick FYI, regarding Staging's r8712u driver.

> >root@hashbang Tue Jun 21 18:30:06 ~$ iwconfig wlan2 essid "h55m"
> >Error for wireless request "Set ESSID" (8B1A) :
> >     SET failed on device wlan2 ; Operation not permitted.
> >root@hashbang Tue Jun 21 18:30:47 ~$ uname -r

> is implemented. Your command failed because you ran the command as
> an unprivileged user. Notice the differences in the error messages.

How is root unprivileged? The shell-prompt shows the user.

Right after the failure, I ran the exact same steps, in the same
shell, on a different card of the same box. It worked, as it always
has.

thanks,
ali
