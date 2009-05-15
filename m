Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40073 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbZEONpJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2009 09:45:09 -0400
Date: Fri, 15 May 2009 09:33:59 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Automatic reassociate with AP
Message-ID: <20090515133359.GB2773@tuxdriver.com>
References: <alpine.LSU.2.00.0905151306240.4165@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <alpine.LSU.2.00.0905151306240.4165@fbirervta.pbzchgretzou.qr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 15, 2009 at 01:10:28PM +0200, Jan Engelhardt wrote:

> when the AP flakes out, or I just appen to be out of range, the kernel 
> drops the AP association, as dmesg shows:
> 
> wlan0: No ProbeResp from current AP 00:0b:0e:4f:cf:80 - assume out of 
> range
> 
> Manually rerunning `iwconfig wlan0 essid FooNet channel 11` 
> reassociates, but I wonder whether the kernel could not do that itself, 
> given that it knows the previous settings like ESSID.

Patches welcome... :-)

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
