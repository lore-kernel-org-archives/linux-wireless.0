Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:43929 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbYAMIpr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jan 2008 03:45:47 -0500
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1JDyTQ-0002Wj-TC
	for linux-wireless@vger.kernel.org; Sun, 13 Jan 2008 08:45:44 +0000
Received: from port-87-193-186-180.static.qsc.de ([87.193.186.180])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jan 2008 08:45:44 +0000
Received: from thomas by port-87-193-186-180.static.qsc.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jan 2008 08:45:44 +0000
To: linux-wireless@vger.kernel.org
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
Subject: Re: [rt2x00] rt2500pci massive speed problems
Date: Sun, 13 Jan 2008 09:45:38 +0100
Message-ID: <fmcj3j$88a$1@ger.gmane.org> (sfid-20080113_084550_621628_56D8BEC6)
References: <fma7v9$cn7$1@ger.gmane.org> <200801121305.16205.IvDoorn@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
In-Reply-To: <200801121305.16205.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ivo van Doorn schrieb:
>> Linux 2.6.24-rc7 (pulled from linux-2.6 git today):
>> The speed is about 20KB/s, which is obviously _much_ slower than the
>> older version above.
>
> Set the rate to 54Mbs instead of auto, other people reported that that should help.

I tested the 2.6.24 case again.

It seems that the rate detection is indeed a problem, as "auto" sets the
rate down to 1Mbs sometimes. Setting it to 54 improves it slightly, but
I still only get about 150KB/s download, as opposed to over 1MB/s with
the legacy driver.

