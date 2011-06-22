Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from msr2.hinet.net ([168.95.4.102]:51398 "EHLO msr2.hinet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757714Ab1FVDTB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 23:19:01 -0400
Date: Wed, 22 Jun 2011 11:17:27 +0800
From: Ali Bahar <ali@internetdog.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: r8712u driver for the rtl8192su chip.
Message-ID: <20110622031727.GA12689@internetdog.org> (sfid-20110622_051906_099982_6F2FD267)
Reply-To: ali@internetdog.org
References: <BANLkTinw+jv8zBi29EKs2K2=tAJMYCEdgQ@mail.gmail.com>
 <4DC0669E.4040100@lwfinger.net>
 <BANLkTikxS_2wJEpijmYQy3nPy2-9pykxdA@mail.gmail.com>
 <4DC06BF3.6070208@lwfinger.net>
 <20110621124954.GA8462@internetdog.org>
 <4E011644.3070906@lwfinger.net>
 <20110622010057.GA12123@internetdog.org>
 <4E0154B7.2000204@lwfinger.net>
 <20110622025623.GC12547@internetdog.org>
 <4E015CE8.3000304@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4E015CE8.3000304@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 21, 2011 at 10:09:28PM -0500, Larry Finger wrote:
> On 06/21/2011 09:56 PM, Ali Bahar wrote:

> >Since you are rewriting this driver, I won't try to dig into this on
> >my end.
> 
> I am not rewriting this driver in the immediate future, thus you
> need to find out what is wrong.

OK.

 
> As I said earlier, your error certainly looks like a privilege
> problem. Adding to what I posted earlier, I get
> 
> finger@larrylap:~> iwconfig wlan9 essid test
> Error for wireless request "Set ESSID" (8B1A) :
>     SET failed on device wlan9 ; Operation not permitted.
> finger@larrylap:~> sudo iwconfig wlan9 essid test
> finger@larrylap:~>
> 
> As you can see, my unprivileged version gets exactly the error
> message that you reported and the one as root works.

I know. 

thanks,
ali
