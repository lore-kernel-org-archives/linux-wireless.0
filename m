Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from msr8.hinet.net ([168.95.4.108]:61141 "EHLO msr8.hinet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757799Ab1FVC55 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 22:57:57 -0400
Date: Wed, 22 Jun 2011 10:56:23 +0800
From: Ali Bahar <ali@internetdog.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: r8712u driver for the rtl8192su chip.
Message-ID: <20110622025623.GC12547@internetdog.org> (sfid-20110622_045800_088125_093F0734)
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
 <4E0154B7.2000204@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4E0154B7.2000204@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> >>>this is more of a quick FYI, regarding Staging's r8712u driver.
> >
> >>>root@hashbang Tue Jun 21 18:30:06 ~$ iwconfig wlan2 essid "h55m"
> >>>Error for wireless request "Set ESSID" (8B1A) :
> >>>     SET failed on device wlan2 ; Operation not permitted.

> I have no idea what you are doing wrong, but I get the following:

Again, the test procedure was identical, and deliberately so.

This was all just FYI; I was just providing some data. Thank you for
your reply, and for your ongoing work.

 
> finger@larrylap:~/wireless-testing-new> sudo iwconfig wlan9 essid junk
> finger@larrylap:~/wireless-testing-new>
> 
> The above is with r8712u running on wireless-testing 3.0-rc4.

I'd tried 3.0.0-rc3-wl_m_Sun19jun2011 (ie wireless rc3, built on
Sunday) as well. Same wext and OS, on a different box.

Since you are rewriting this driver, I won't try to dig into this on
my end.

thanks,
ali
