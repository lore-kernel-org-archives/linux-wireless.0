Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta-2.ms.rz.RWTH-Aachen.DE ([134.130.7.73]:45484 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759674Ab0HEH6P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Aug 2010 03:58:15 -0400
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Message-id: <4C5A6EFE.7040703@arndnet.de>
Date: Thu, 05 Aug 2010 09:57:50 +0200
From: Arnd Hannemann <arnd@arndnet.de>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	sfr@canb.auug.org.au
Subject: Re: GIT: net-*2.6 rebased...
References: <20100804.162141.15218463.davem@davemloft.net>
In-reply-to: <20100804.162141.15218463.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Am 05.08.2010 01:21, schrieb David Miller:
> 
> Both net-2.6 and net-next-2.6 have been rebased.
> 
> To be honest, if you've been pulling from my tree you can just keep
> doing so if you want, it will look just as if I had merged Linus's
> tree into net-2.6 et al.

I there something broken with the trees on git.kernel.org?

if I try to fetch from net-next-2.6, I get:
fatal: The remote end hung up unexpectedly

if I try to clone net-2.6:
(e.g. git clone git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6.git

I get lots of errors reading the tags "does not point to a valid object!" and then:
remote: error: Could not read 3cfc2c42c1cbc8e238bb9c0612c0df4565e3a8b4
remote: fatal: Failed to traverse parents of commit 7aaaaa1e44b2a4047dfe05f304a5090eb995cf44
remote: aborting due to possible repository corruption on the remote side.
fatal: early EOF
fatal: index-pack failed

I'm using git version 1.7.1.

Best regards,
 Arnd
