Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50904 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331Ab2LUAuw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2012 19:50:52 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1TlqpL-000066-Cb
	for linux-wireless@vger.kernel.org; Fri, 21 Dec 2012 01:51:03 +0100
Received: from 123.151.195.1 ([123.151.195.1])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 21 Dec 2012 01:51:03 +0100
Received: from cash.q by 123.151.195.1 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 21 Dec 2012 01:51:03 +0100
To: linux-wireless@vger.kernel.org
From: cashq <cash.q@hotmail.com>
Subject: Re: ath6kl in compat wireless supports AP mode?
Date: Fri, 21 Dec 2012 00:50:32 +0000 (UTC)
Message-ID: <loom.20121221T014532-248@post.gmane.org> (sfid-20121221_015118_296119_9FE858E9)
References: <7d44469343059cc380b51910982d03fd.squirrel@www.infidigm.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 <drwho@...> writes:

> 
> cashq,
> 
> AR6003 is working for me with hostapd...
> 
> platform = arm imx51
> kernel = 2.6.35.3-998
> compat-wireless = "Backport based on linux-stable.git v3.4-rc3"
> hostapd = v1.0
> .... 

Hi DrWho,

Thank you so much. It turns out that I took an incorrect version of hostapd-
0.7.3. After using hostapd-1.0, AP mode has been successfully enabled.

Regards,
cashq



