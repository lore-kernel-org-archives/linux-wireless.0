Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:49009 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758351Ab0HOQHE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Aug 2010 12:07:04 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Oke92-0007Dl-7I
	for linux-wireless@vger.kernel.org; Sun, 15 Aug 2010 16:25:04 +0200
Received: from 94-194-49-83.zone8.bethere.co.uk ([94.194.49.83])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 15 Aug 2010 16:25:04 +0200
Received: from linuxwireless by 94-194-49-83.zone8.bethere.co.uk with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 15 Aug 2010 16:25:04 +0200
To: linux-wireless@vger.kernel.org
From: Fritz <linuxwireless@crusius.info>
Subject: RTL8192E Kernel 2.6.32 Freeze
Date: Sun, 15 Aug 2010 14:17:55 +0000 (UTC)
Message-ID: <loom.20100815T155457-704@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm using the RTL8192E (r8192_pci) staging driver 
that comes with ubuntu kernel 2.6.32-24 and am 
experiencing frequent freezes on an 
Intel Atom N450 based system.

Is this a known problem and is there perhaps a newer
kernel that I should build and run instead?

The freeze seems to occur whenever the card reconnects
with the router, see for more detailed problem
description
http://ubuntuforums.org/showthread.php?t=1549483

Cheers,
Fritz




