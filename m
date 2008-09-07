Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:61959 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752596AbYIGAgB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 20:36:01 -0400
Message-ID: <48C321EF.30909@lwfinger.net> (sfid-20080907_023605_334259_356B2E92)
Date: Sat, 06 Sep 2008 19:35:59 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: gavron@wetwork.net
CC: Broadcom Wireless <bcm43xx-dev@berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Speed enhancement for BCM4306/2
References: <48C1BA91.7050106@lwfinger.net> <48C20928.10202@wetwork.net> <48C20BD7.6080605@lwfinger.net> <48C20F64.1000700@wetwork.net> <48C2A1F5.6020607@lwfinger.net> <48C30B3E.2040302@wetwork.net> <48C3121C.9090309@lwfinger.net> <48C31646.2020205@wetwork.net> <48C31DBB.6000709@lwfinger.net> <48C31F65.2000406@wetwork.net>
In-Reply-To: <48C31F65.2000406@wetwork.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

gavron@wetwork.net wrote:
> 
> Try #5:
> # diff -uN /tmp/phy.c drivers/net/wireless/b43legacy/phy.c
> --- /tmp/phy.c    2008-09-06 15:13:33.000000000 -0700

This one is pretty close, but I think you missed a change at line 16a 
of B6PHY.

One other thing - use the -uNp switch for diff.

Larry

