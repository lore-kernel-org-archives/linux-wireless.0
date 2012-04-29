Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2143 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561Ab2D2IN4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Apr 2012 04:13:56 -0400
Message-ID: <4F9CF839.1040401@broadcom.com> (sfid-20120429_101438_590538_516BA0E9)
Date: Sun, 29 Apr 2012 10:13:45 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/19] brcmsmac: use sprom and PCIe code from bcma
References: <1335660643-26368-1-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1335660643-26368-1-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/29/2012 02:50 AM, Hauke Mehrtens wrote:
> I have not completely runtime tested these patches as I do not have a
> PCI(e) devices currently supported by brcmsmac. My SoC (BCM4718) and
> the PCI devices connected to my SoC (BCM43224) are currently not
> working with brcmsmac, but they are failing much later that without
> these patches.

I will test this patch series as well on PCI(e) devices. So you do have 
a bcm43224 card, but no laptop to fit it in? Just wondering. I will send 
the results.

Gr. AvS

