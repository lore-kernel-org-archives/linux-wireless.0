Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from li12-156.members.linode.com ([70.85.129.156]:54038 "EHLO
	defaultvalue.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbZKGWSH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 17:18:07 -0500
From: Rob Browning <rlb@defaultvalue.org>
To: linux-wireless@vger.kernel.org, hostap@lists.shmoo.com
Subject: Re: ath9k based AP stops responding after half a day or so
References: <87my37if04.fsf@raven.defaultvalue.org>
Date: Sat, 07 Nov 2009 14:18:12 -0800
In-Reply-To: <87my37if04.fsf@raven.defaultvalue.org> (Rob Browning's message
	of "Sat, 31 Oct 2009 11:40:11 -0700")
Message-ID: <87skcqgesb.fsf@raven.defaultvalue.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rob Browning <rlb@defaultvalue.org> writes:

> I have an machine that's running a recent compat-wireless (2009-10-17),
> kernel 2.6.30-2-686 (Debian), and a build of hostapd as of 2009-10-17
> (08d38568).  The machine also has an AR5008 (ath9k) based PCI card.
>
> After the machine reboots, wireless clients can connect to the AP
> normally for a half day or so.  Then, at some point, all connections
> fail, and clients cannot even see the network until the machine is
> rebooted.  Reloading the wireless modules, and restarting hostapd
> doesn't help.

Just as an update, this problem persists with hostapd as of eb999fef,
and compat-wireless 2009-11-03.

I'd be happy to provide further information.
-- 
Rob Browning
rlb @defaultvalue.org and @debian.org; previously @cs.utexas.edu
GPG as of 2002-11-03 14DD 432F AE39 534D B592 F9A0 25C8 D377 8C7E 73A4
