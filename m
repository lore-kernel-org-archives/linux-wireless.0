Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f50.google.com ([209.85.219.50]:57791 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760348AbaGEAue convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jul 2014 20:50:34 -0400
Received: by mail-oa0-f50.google.com with SMTP id n16so2367469oag.9
        for <linux-wireless@vger.kernel.org>; Fri, 04 Jul 2014 17:50:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1404521310-502-1-git-send-email-zajec5@gmail.com>
References: <1404521310-502-1-git-send-email-zajec5@gmail.com>
Date: Sat, 5 Jul 2014 02:50:33 +0200
Message-ID: <CACna6ryUq6f-V3tUtXs+LUK6V7kdBrzEOtYvuH5M56tuEg5f6Q@mail.gmail.com> (sfid-20140705_025037_482170_A1C069F7)
Subject: Re: [RFC][PATCH] bcma: support for PCIe Gen 2 as host platform
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5 July 2014 02:48, Rafał Miłecki <zajec5@gmail.com> wrote:
> I dumped LNKCAP on most of my devices and it seems we can use
> PCI_EXP_LNKCAP_SLS_5_0GB to determine if device is PCIe 2.0.

I accidentally dropped beginning of the message:

I couldn't find any nice way to check if device is PCIe 2.0 or not. I
tried asking on linux-pci@, but without any answer so far:
http://marc.info/?t=140441806600004&r=1&w=2
