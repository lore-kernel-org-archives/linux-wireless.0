Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4087 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087Ab2DQTUr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2012 15:20:47 -0400
Message-ID: <4F8DC25E.9090702@broadcom.com> (sfid-20120417_212051_380732_7747364C)
Date: Tue, 17 Apr 2012 21:19:58 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Dominik Feser" <dominik.feser@googlemail.com>
cc: linux-wireless@vger.kernel.org,
	"Wey-Yi Guy" <wey-yi.w.guy@intel.com>,
	"Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: wlan0 not present
References: <2F08FF0B-5C29-4827-AA5F-B0F3847D0B83@gmail.com>
In-Reply-To: <2F08FF0B-5C29-4827-AA5F-B0F3847D0B83@gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/17/2012 07:59 PM, Dominik Feser wrote:
> Hi!
> Maybe someone can help me. I have compiled and installed compat-wireless-3.4-rc1-2 and it seems to load correctly. The thing I am missing is the wlan0 device.
>
> # lspci -kvm
> Device:	02:00.0
> Class:	Network controller
> Vendor:	Intel Corporation
> Device:	Centrino Advanced-N 6205
> SVendor:	Intel Corporation
> SDevice:	Centrino Advanced-N 6205 AGN
> Rev:	34
> Module:	iwlwifi
>
> Nothing...
>
> Maybe some thoughts?
>

I am not too familiar with iwlwifi or compat-wireless, but it seems the 
driver did not start successfully. Did it work before trying 
compat-wireless? Can you provide full dmesg output instead of filter it 
with grep? Can you enable Driver-API tracing in mac80211?

Gr. AvS

