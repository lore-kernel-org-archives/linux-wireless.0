Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:54955
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbXDHNvD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Apr 2007 09:51:03 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Reyk Floeter <reyk@openbsd.org>
Subject: Re: OpenBSD bcw: Possible GPL license violation issues
Date: Sun, 8 Apr 2007 15:50:22 +0200
Cc: proski@gnu.org, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org,
	Marcus Glocker <mglocker@openbsd.org>,
	Theo de Raadt <deraadt@theos.com>
References: <200704041945.21447.mb@bu3sch.de> <20070408132743.GA12836@slim.vantronix.net>
In-Reply-To: <20070408132743.GA12836@slim.vantronix.net>
MIME-Version: 1.0
Message-Id: <200704081550.22579.mb@bu3sch.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 08 April 2007 15:27, Reyk Floeter wrote:
> You either totally misinterpreted my statements or you just want to
> spread the FUD that every OpenBSD developer is mind-controlled by
> Theo. I involved Theo _after_ I denied the various requests to change
> the license of my driver because the various people didn't stop to
> repeat their requests. You involved lawyers to question my code.
> 
> Instead of attacking developers of non-GPL free software, you should
> point your lawyers into another direction to think about ways to
> include GPL-compatible BSD/ISC code in the Linux kernel without the
> need for relicensing it. Talk to the Linux maintainers to change this
> stupid Dual GPL/* policy.
> 
> It is your choice, you can also rewrite the "OpenHAL" and take my code
> as a reference. The copyright does not protect the "idea" of the
> implementation or the algorithms. Feel free to read my code, interpret
> it and express it differently.

Excuse my ignorance, please, but I don't see where the real problem is.
What's the problem with taking openHAL and putting it into the yet to
be written GPLed linux atheros driver, while preserving your copyright
notices. I don't see how this could violate the BSD license.

Such stuff is going on day by day. One good example of BSD code put into
code with another license was MS with the NT TCP stack. At least of my
knowledge that was the FreeBSD stack, until they rewrote it.

So, what's the problem, really? Create a derivative work, where
the original openHAL parts are still de-facto BSD licensed, but the rest
is GPLed.

> From my point of view GPL software is non-free because I cannot simply
> reuse it in my code. It may work within the Linux world, but everybody
> else is restricted from using it. This is especially a problem when we
> depend on the Linux drivers as the only reference to write drivers for
> OpenBSD.

Well, so is the license. Put your work under the GPL and you are
free to use the code. (Or alternatively ask the copyright holder(s)
to relicense).

-- 
Greetings Michael.
