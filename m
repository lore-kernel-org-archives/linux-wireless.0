Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hell.pl ([193.219.28.162]:58362 "EHLO hell.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751715AbZDJWxX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Apr 2009 18:53:23 -0400
Received: from krecik by hell.pl with local (Exim 4.63)
	(envelope-from <krecik@hell.pl>)
	id 1LsOS6-00042x-Vy
	for linux-wireless@vger.kernel.org; Fri, 10 Apr 2009 23:39:59 +0200
Date: Fri, 10 Apr 2009 23:39:58 +0200
From: Grzegorz Nowakowski <krecik@hell.pl>
To: linux-wireless@vger.kernel.org
Subject: ath5k blind to nearby network
Message-ID: <20090410213958.GA12571@hell.pl> (sfid-20090411_005328_213790_829C4DAC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello everyone,

I'm more or less ordinary Linux user: have used the system for a long
time.  While I'm accustomed to manual tweaking of the system, I gave up
regarding set up of secure wireless connection.  I rely on the tools,
networkmanager at the beginning, wicd now, to do the job.  Which was
performed rather well except lately, when I encounter strange problem.

The short version is: my laptop doesn't see my home network (and can't
connect to, too).

For longer one, there is needed some background.  The AP used is Motorola
WR850G running DD-WRT v24-sp1 (and v24-beta few months earlier).  The
laptop is Fujitsu-Siemens Lifebook E8310 with Atheros AR242x built in.
For reference, there is also another laptop, HP, with Intel IPW2200 on
board.  Both laptops run on Debian unstable with unpatched, custom configured
2.6.29.1 kernel.  What works or worked:

- HP
- FSC with Madwifi long time ago
- FSC running Windows XP
- FSC with Linux&ath5k few months ago

What doesn't:
- FSC with Linux&ath5k now
- FSC with Knoppix 6.1

The symptom is that with both NetworkManager and WICD (and "iwlist <if>
scanning") I don't see my home network on the list.  I see all other
neighbouring networks around and I'm even able to connect if any is
open.  Too much power on AP is not an issue as I lowered it to pathetic
level (30mW), besides HP doesn't complain.  Problem is probably not with
hardware nor with AP as WinXP on FSC connects flawlessly.

The only uncertainity is with the DD-WRT version as I'm not 100% sure if
the FSC worked after the firmware upgrade.  Most probably, yes.  Anyway,
WinXP still works.

I mentioned Madwifi only for completness.  I had bad experience with the
driver and I'm not going to use it unless I get really good argument
("it works for me" is not such one).

In summary, the problem seems to lie somewhere around ath5k driver on
this paritcular laptop connecting to this particular access point.  Now
I have no reason to believe there is an error in ath5k but I'm at loss
what to check more.  So maybe someone suggest what additional diagnosis
can I perform to better isolate the glitch?  Any suggestion is welcome.

As I don't subscribe to this list, please CC me when replying.

Thanks in advance and best regards,
-- 
Grzegorz Nowakowski
