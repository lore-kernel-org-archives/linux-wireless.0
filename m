Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4338 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562Ab2D2IFf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Apr 2012 04:05:35 -0400
Message-ID: <4F9CF642.1000705@broadcom.com> (sfid-20120429_100621_906597_43DE55A5)
Date: Sun, 29 Apr 2012 10:05:22 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: linville@tuxdriver.com, zajec5@gmail.com,
	b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/4] bcma: add PCI functions from brcmsmac
References: <1335658732-24351-1-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1335658732-24351-1-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/29/2012 02:18 AM, Hauke Mehrtens wrote:
> This patch series contains the functions regarding the PCIe core from
> brcmsmac for the supported PCIe core revisions.
>
> Some of these functions have to be called on resume after suspend, but
> I do not know which or if all have to be called. I do not have a PCIe
> based device supported by brcmsmac, so I can not test this. Could
> someone which such a device do some tests and create a patch with the
> functions, which have to be called on resume.

I do have some devices and feel it is my/our responsibility to get this 
tested. I let you know the results.

> The goal of theses patches is to remove the PCIe code from brcmsmac to
> get one step ahead in making brcmsmac support non pcie based devices.
>
> This is based on wireless-testing/master.
>

Gr. AvS

