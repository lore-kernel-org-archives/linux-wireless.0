Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55904 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757798Ab2COWk3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 18:40:29 -0400
Message-ID: <4F626FCB.6010103@hauke-m.de> (sfid-20120315_234041_621496_CD44EAE8)
Date: Thu, 15 Mar 2012 23:40:11 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: stern@rowland.harvard.edu, linux-mips@linux-mips.org,
	ralf@linux-mips.org, m@bues.ch, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4 4/7] USB: Add driver for the bcma bus
References: <1331597093-425-1-git-send-email-hauke@hauke-m.de> <1331597093-425-5-git-send-email-hauke@hauke-m.de> <20120315194426.GA30682@kroah.com>
In-Reply-To: <20120315194426.GA30682@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/15/2012 08:44 PM, Greg KH wrote:
> On Tue, Mar 13, 2012 at 01:04:50AM +0100, Hauke Mehrtens wrote:
>> This adds a USB driver using the generic platform device driver for the
>> USB controller found on the Broadcom bcma bus. The bcma bus just
>> exposes one device which serves the OHCI and the EHCI controller at the
>> same time. This driver probes for this USB controller and creates and
>> registers two new platform devices which will be probed by the new
>> generic platform device driver. This makes it possible to use the EHCI
>> and the OCHI controller on the bcma bus at the same time.
>>
>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>> ---
>>  drivers/usb/host/Kconfig    |   12 ++
> 
> This patch fails to apply here, and I can't seem to figure out what tree
> you made this against to fix it up by hand on my end.
> 
> Any thoughts?
> 
> greg k-h

This patch was against
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git#master, but
I will rebase it onto usb/usb-next and send a new version of the patches
you have not applied.

Hauke
