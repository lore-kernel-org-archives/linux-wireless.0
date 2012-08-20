Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36178 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663Ab2HTKpP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2012 06:45:15 -0400
Message-ID: <1345459509.4459.5.camel@jlt3.sipsolutions.net> (sfid-20120820_124520_308700_CFC673E8)
Subject: Re: Missing firmware iwlwifi-2030-5.ucode
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ben Hutchings <ben@decadent.org.uk>
Date: Mon, 20 Aug 2012 12:45:09 +0200
In-Reply-To: <502D0C72.2050207@lwfinger.net> (sfid-20120816_170635_404509_F239FBF6)
References: <502D0C72.2050207@lwfinger.net>
	 (sfid-20120816_170635_404509_F239FBF6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

> I am trying to help an openSUSE 12.1 user who is running kernel 3.1.9, who has 
> an Intel 802.11 b/g/n card with Bluetooth mounted in an HP dvdt-7000 Quad 
> Edition Series computer.
> 
> The driver is asking for firmware named "iwlwifi-2030-5.ucode"; however, that 
> particular file does not exist in /lib/firmware, nor is in the linux-firmware 
> git repo where only the version 6 firmware exists.
> 
> I could find no record of the firmware ever being in the git repo, nor could I 
> find it using a Google search. For users of kernel 3.1, I request that this 
> firmware file be submitted to linux-firmware. In addition, if you send me a copy 
> of the file, I will see that the OP on the openSUSE Forum gets a copy.

Unfortunately, I can't just release this firmware, it was mostly
internal experimental builds, we released the -6 version later. However,
as Thomas pointed out, it should be possible to backport some patches to
make the driver in 3.1.9 work with the device, that simply wasn't a
concern for us and it's not entirely clear to me that such patches are
candidates for stable.

johannes

