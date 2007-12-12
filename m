Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:37637 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbXLLMCr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2007 07:02:47 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Randy Cushman <rcushman_linux@roadrunner.com>
Subject: Re: BCM4306 Questions
Date: Wed, 12 Dec 2007 13:00:59 +0100
Cc: linux-wireless@vger.kernel.org
References: <475F2DAD.4000708@roadrunner.com> <200712121214.50522.mb@bu3sch.de> <475FCB46.2030209@roadrunner.com>
In-Reply-To: <475FCB46.2030209@roadrunner.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200712121300.59811.mb@bu3sch.de> (sfid-20071212_120250_989684_BF710129)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 12 December 2007 12:51:34 Randy Cushman wrote:
> I'm not sure I follow.  Are you telling me that driver version 
> 4.150.29.0 does not contain firmware "officially supported" by the Linux 
> Wireless project because no one more knowledgeable than I has gotten 
> around to adding its signature to bcm43xx-fwcutter?

The linux driver does only support the officially supported version.
Any other version might not work at all.

> Are you telling me that I need to temporarily install an older driver in 
> Windows so bcm43xx-fwcutter can have access to an older version of 
> BCMWL5.SYS to work with?  (By my reading of the source code, 
> b43-fwcutter does not recognize /any/ version of BCMWL5.SYS.)

Not at all.
You have to read the webpage. Here's the link again:
http://www.linuxwireless.org/en/users/Drivers/b43#devicefirmware
Everything is described there.

-- 
Greetings Michael.
