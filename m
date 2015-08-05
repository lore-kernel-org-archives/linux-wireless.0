Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:12283 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750809AbbHEIkR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2015 04:40:17 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Julien Cubizolles <j.cubizolles@free.fr>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Nishant Sarmukadam" <nishants@marvell.com>
Subject: RE: firmware in a bad state (module mwifiex)
Date: Wed, 5 Aug 2015 08:40:12 +0000
Message-ID: <d74ef56802d24c8e90e1b82eb5003172@SC-EXCH04.marvell.com> (sfid-20150805_104023_192315_F83B4D64)
References: <871tfzast5.fsf@free.fr>
	<0e2dc4e2bd9f4486979cedb4c47e60f2@SC-EXCH04.marvell.com>
 <87zj26z1pd.fsf_-_@free.fr>
In-Reply-To: <87zj26z1pd.fsf_-_@free.fr>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Julien,

> From: Julien Cubizolles [mailto:j.cubizolles@free.fr]
> Sent: Wednesday, August 05, 2015 12:01 PM
> To: Amitkumar Karwar
> Cc: linux-wireless@vger.kernel.org
> Subject: firmware in a bad state (module mwifiex)
> 
> 
> I'm running kernel 4.2.0-rc3 with the following patches to the mwifiex
> driver, thanks to your advice.
> 
> > Do you have following USB chipset specific fixes included?
> > http://www.spinics.net/lists/linux-wireless/msg129129.html
> > http://www.spinics.net/lists/netdev/msg334367.html
> 
> I've recently noticed that the connection is lost (and the driver too
> only rebooting makes the card usable again) when I connect to certain
> websites (github for instance)
> I've set debugging up with the following command, and attached the
> output from dmesg.

This looks like a command timeout problem probably caused due to a bug in firmware.
How frequently do you see this problem? Are there any specific steps to recreate it?

Regards,
Amit
