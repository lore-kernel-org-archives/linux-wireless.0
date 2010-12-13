Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:41497 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758452Ab0LMRZS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 12:25:18 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1PSC9B-00087Q-Bs
	for linux-wireless@vger.kernel.org; Mon, 13 Dec 2010 18:25:13 +0100
Received: from 77.119.210.143.wireless.dyn.drei.com ([77.119.210.143])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 13 Dec 2010 18:25:13 +0100
Received: from messier31 by 77.119.210.143.wireless.dyn.drei.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 13 Dec 2010 18:25:13 +0100
To: linux-wireless@vger.kernel.org
From: Thomas <messier31@gmx.net>
Subject: Re: carl9170 802.11n-AP
Date: Mon, 13 Dec 2010 18:24:57 +0100
Message-ID: <ie5kt9$vfp$1@dough.gmane.org>
References: <loom.20101212T101545-636@post.gmane.org> <loom.20101212T110657-413@post.gmane.org> <AANLkTimiNLZ8EFPEwbKW3UA7FMSxmJOV-B9pWY4h9c34@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Today I tried a different wifi card on the client side, instead of the Intel 
5100, but the problem remains the same. The carl9170 driver on my server 
crashes at some point randomly (only in 802.11n mode). The traceback shows 
the error at tx.c but everytime in a different line. So I guess there must 
be a race condition somewhere.

Here you can find the error report of some crashes: 
http://www.mikrocontroller.net/attachment/95144/bugreport.txt

Server hardware is a Seagate Dockstar with OpenWrt running on it. I heard 
from another user with Debian, who has the same problem.

Regards,

Thomas


