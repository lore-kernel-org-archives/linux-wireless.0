Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm16-vm1.bullet.mail.ird.yahoo.com ([77.238.189.88]:38866 "HELO
	nm16-vm1.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750980Ab0KVQka convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 11:40:30 -0500
Message-ID: <370521.43644.qm@web29514.mail.ird.yahoo.com>
Date: Mon, 22 Nov 2010 16:40:28 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: RTL8187L: Can only "enable" hw radio switch after Windows boot
To: Klaas De Craemer <klaasdc@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
In-Reply-To: <4CEA9903.6070604@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Mon, 22/11/10, Larry Finger <Larry.Finger@lwfinger.net> wrote:

> Date: Monday, 22 November, 2010, 16:23
> On 11/22/2010 02:59 AM, Klaas De
> Craemer wrote:
> > 
> > Sorry, I meant I get a few errors in the form of
> "SIOCSIFFLAGS:
> > Unknown error 132" on the stdout when trying to bring
> up the blocked
> > interface.
> 
> Do those errors also occur when it works, or just when it
> is blocked?
> 
> Is it possible to keep the box in a warm place to see if it
> is temperature
> related? The problem of it working with Windows is still
> puzzling. As your Atom
> is 32 bit, there is the possibility of trying ndiswrapper
> with the Windows XP
> driver. Oh it hurts to write that, but that would isolate
> the problem to rtl8187.

I was going to comment if the problem is warm-reboot/cool-reboot related. I had an impression at some point in the past that the windows driver messes with the internal state of the 8187B device, such that it does not work under linux after a warm-boot from windows (i.e. you need to do "shutdown" in windows and presses the power-switch to go into linux, rather than "reboot", and select "linux" at the boot-loader prompt). Although I don't think this is the current situation - I don't often warm-reboot, and in any case, seldomly use wireless under windows - I think the in-kernel driver these days reset the device's state on start-up better or something, so my impression may not be valid; but if you are using a slightly older in-kernel driver, in combination with rebooting to windows, etc, that might be the case.



      
