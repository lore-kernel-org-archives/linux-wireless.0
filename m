Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:42531 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756995AbYE0MqQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2008 08:46:16 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: oops on b43 insertion on mips
Date: Tue, 27 May 2008 14:45:49 +0200
Cc: linux-wireless@vger.kernel.org
References: <483B105E.4090800@wpkg.org> <200805262225.19007.mb@bu3sch.de> <483B1F82.1010902@wpkg.org>
In-Reply-To: <483B1F82.1010902@wpkg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200805271445.49665.mb@bu3sch.de> (sfid-20080527_144618_975227_C1C65171)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 26 May 2008 22:37:22 Tomasz Chmielewski wrote:
> Michael Buesch schrieb:
> > On Monday 26 May 2008 21:32:46 Tomasz Chmielewski wrote:
> >> I just compiled 2.6.25.4 for BCM47XX (little endian MIPS).
> 
> > Are you running openwrt?
> > It currently has a linkage bug. People are working on it.
> > If you're not running openwrt, please provide useful debugging information.
> 
> Yes, it is build from openwrt sources.
> 
> Do you have any pointers to that linkage bug (where it was discussed etc.)?

It's discussed in a private developer channel.
The fix will be committed as soon as it is available.

PS: Next time please submit these bugreports to the openwrt bugzilla.
    That's really the only place where you can find help.
    But you don't need to post this bug to bugzilla, as its fix is
    work in progress and will be committed when it's done.

-- 
Greetings Michael.
