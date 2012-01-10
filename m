Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4708 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752815Ab2AJLIR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jan 2012 06:08:17 -0500
Message-ID: <4F0C1C0C.2020504@broadcom.com> (sfid-20120110_120821_644523_B47C2D9F)
Date: Tue, 10 Jan 2012 12:07:56 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Larry Finger" <Larry.Finger@lwfinger.net>
cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	b43-dev <b43-dev@lists.infradead.org>,
	"Abimanyu Gottumukkala" <me@abimanyu.in>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: BCM43231
References: <CAEWwF+bnM0bxbZR6B57H_nv3fkUdhP-ytAu30MLhUWq7QxB3GQ@mail.gmail.com>
 <CACna6rzNrFWBJ+n3n9wrnP_Gi3LKCWt+o1Gs38_EjkMgG_k8vg@mail.gmail.com>
 <4F0B67BA.20207@lwfinger.net>
In-Reply-To: <4F0B67BA.20207@lwfinger.net>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/09/2012 11:18 PM, Larry Finger wrote:
> 
> I remember seeing some mail about the Broadcom guys working on a Linux driver 
> for a USB fullmac device. Is this the one? (I added Arend to the Cc.)
> 
> Larry
> 

As you know we currently have two linux drivers. brcmfmac is a fullmac
architecture for cfg80211, brcmsmac is a softmac architecture for
mac80211. The brcmfmac driver will get usb support soon (when I finish
my testing over here) but it supports another device (ie. bcm43236).

The bcm43231 has another architecture and can not be supported by either
of the drivers.

Gr. AvS

