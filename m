Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4392 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758119Ab2JXLBe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2012 07:01:34 -0400
Message-ID: <5087CA82.5070902@broadcom.com> (sfid-20121024_130138_218166_72B5D365)
Date: Wed, 24 Oct 2012 13:01:22 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Larry Finger" <Larry.Finger@lwfinger.net>
cc: "Franky Lin" <frankyl@broadcom.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Driver for USB device with ID 050d:615a
References: <5087035E.9010609@lwfinger.net>
In-Reply-To: <5087035E.9010609@lwfinger.net>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/23/2012 10:51 PM, Larry Finger wrote:
> Arend and Franky,
>
> I recently purchased a Belkin N600 DB USB dongle on Ebay. I wanted to
> get the model with a Realtek RTL8192DU chip. Instead I got a version
> with a Broadcom chip, which lsusb identifies as
>
> Bus 001 Device 005: ID 050d:615a Belkin Components F7D4101 / F9L1101
> 802.11abgn Wireless Adapter [Broadcom BCM4323]
>
> I have since acquired a different device with the Realtek chip, thus I
> could return the Belkin device; however, the cost was minimal and I will
> keep it if there is a driver for it. Is it a brcmfmac device that is not
> yet in the device tables, or is it some other sort of unit that may
> never be supported under Linux?

Hi Larry,

I went digging and this chip requires a different driver model 
(basically a split stack between host and dongle). This model is being 
abandoned for newer chips so we decided not to support it in mainline linux.

Gr. AvS


