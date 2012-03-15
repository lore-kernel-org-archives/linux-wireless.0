Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55942 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761064Ab2COWnp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 18:43:45 -0400
Message-ID: <4F627092.7030207@hauke-m.de> (sfid-20120315_234350_918234_0E2901B9)
Date: Thu, 15 Mar 2012 23:43:30 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: stern@rowland.harvard.edu, linux-mips@linux-mips.org,
	ralf@linux-mips.org, m@bues.ch, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4 3/7] bcma: scan for extra address space
References: <1331597093-425-1-git-send-email-hauke@hauke-m.de> <1331597093-425-4-git-send-email-hauke@hauke-m.de> <20120315194453.GB30682@kroah.com>
In-Reply-To: <20120315194453.GB30682@kroah.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/15/2012 08:44 PM, Greg KH wrote:
> On Tue, Mar 13, 2012 at 01:04:49AM +0100, Hauke Mehrtens wrote:
>> Some cores like the USB core have two address spaces. In the USB host
>> controller one address space is used for the OHCI and the other for the
>> EHCI controller interface. The USB controller is the only core I found
>> with two address spaces. This code is based on the AI scan function
>> ai_scan() in shared/aiutils.c in the Broadcom SDK.
>>
>> CC: Rafał Miłecki <zajec5@gmail.com>
>> CC: linux-wireless@vger.kernel.org
>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>> ---
>>  drivers/bcma/scan.c       |   19 ++++++++++++++++++-
>>  include/linux/bcma/bcma.h |    1 +
>>  2 files changed, 19 insertions(+), 1 deletions(-)
> 
> Is this required for the 4/7 patch?
> 
> If so, can I get an ack from the BCMA developers so that I can take this
> through the USB tree?
> 
> thanks,
> 
> greg k-h

Hi Rafał,

could you give me an ack for this patch please.

This patch is only required for the patch "Add driver for the bcma bus".

Hauke
