Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3738 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756055Ab2FNQqz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 12:46:55 -0400
Message-ID: <4FDA1544.1020701@broadcom.com> (sfid-20120614_184658_811893_DB5EDD24)
Date: Thu, 14 Jun 2012 09:45:56 -0700
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: "Wei Ni" <wni@nvidia.com>
cc: "Stephen Warren" <swarren@nvidia.com>,
	"'linux-wireless@vger.kernel.org'" <linux-wireless@vger.kernel.org>,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
	"'linux-mmc@vger.kernel.org'" <linux-mmc@vger.kernel.org>,
	"devicetree-discuss@lists.ozlabs.org"
	<devicetree-discuss@lists.ozlabs.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"Mursalin Akon" <makon@nvidia.com>,
	"Rakesh Kumar" <krakesh@nvidia.com>
Subject: Re: Where to power on the wifi device before loading the
 driver.
References: <6B4D417B830BC44B8026029FD256F7F1C377BFFE88@HKMAIL01.nvidia.com>
 <4FD8CED9.6030901@broadcom.com>
 <6B4D417B830BC44B8026029FD256F7F1C377BFFE89@HKMAIL01.nvidia.com>
In-Reply-To: <6B4D417B830BC44B8026029FD256F7F1C377BFFE89@HKMAIL01.nvidia.com>
Content-Type: text/plain;
 charset=windows-1252;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/13/2012 09:17 PM, Wei Ni wrote:
> Wei: Yes, in OOB mode, it's easy to add a device node in the DT, to pass
> the gpio property to brcmfmac driver. But the NO-OOB mode doesn’t use the
> virtual platform device, so we can't pass the gpio to driver. We need to find
> a way to support these two mode both.
> Could we use the virtual platform device both for OOB and NO-OOB mode? so that
> we can implement power control in these two mode, and we can add a flags to
> control if need to power on or not.

Of course you can use it for non OOB.

> BTW, does that power on sequence is generally for 4329?

Yes.

Regards.
Franky

