Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:47989 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752491AbZGaTDQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 15:03:16 -0400
Message-ID: <4A733FF1.7050301@gmx.de>
Date: Fri, 31 Jul 2009 21:03:13 +0200
From: Joerg Albert <jal2@gmx.de>
MIME-Version: 1.0
To: Mladen Horvat <acid-burn@opendreambox.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: zd1211rw with MIPS architecture: mysterious behavior with zd1211b
 and AL2230/AL2230S RF Chip
References: <loom.20090731T125828-710@post.gmane.org>
In-Reply-To: <loom.20090731T125828-710@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/31/2009 03:11 PM, Mladen Horvat wrote:

> the same stick runs flawless on a x86 pc with kernel 2.6.30.
> as i said, also on the same machine with kernel 2.6.12 and the vendor driver
> this stick works without problems.
> 
> perhaps someone has an idea ?

Just a wild guess, if your target runs MIPS in big endian: a missing endian conversion in the zd1211rw driver?
Wasn't USB little-endian based?

If the stick runs on the same MIPS target with 2.6.12 and vendor driver, it shouldn't be a USB 1.1 vs. 2.0
problem - I guess the stick is a high speed device, as the zd1211b supports 802.11g.

Regards,
Joerg.
