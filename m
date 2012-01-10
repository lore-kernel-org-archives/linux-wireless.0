Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3784 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752955Ab2AJMRk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jan 2012 07:17:40 -0500
Message-ID: <4F0C2C4E.7050802@broadcom.com> (sfid-20120110_131743_613197_20270C1C)
Date: Tue, 10 Jan 2012 13:17:18 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "Larry Finger" <Larry.Finger@lwfinger.net>,
	b43-dev <b43-dev@lists.infradead.org>,
	"Abimanyu Gottumukkala" <me@abimanyu.in>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: BCM43231
References: <CAEWwF+bnM0bxbZR6B57H_nv3fkUdhP-ytAu30MLhUWq7QxB3GQ@mail.gmail.com>
 <CACna6rzNrFWBJ+n3n9wrnP_Gi3LKCWt+o1Gs38_EjkMgG_k8vg@mail.gmail.com>
 <4F0B67BA.20207@lwfinger.net> <4F0C1C0C.2020504@broadcom.com>
 <CACna6ry75+cW=M4gAFbf6E3aBqbfKUYEpnkZNAMwTsEvLAg3JA@mail.gmail.com>
In-Reply-To: <CACna6ry75+cW=M4gAFbf6E3aBqbfKUYEpnkZNAMwTsEvLAg3JA@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/10/2012 12:14 PM, Rafał Miłecki wrote:
> 
> Can you check what chipset is 0846:9020? I didn't see any prove it's
> BCM43231 so far. Can you confirm/deny this?
> 
> Firmware upload of Windows driver for 0846:9020 looks similar to brcmfmac.
> 

Broadcom usb id's start with 0a5c so for the ID above I can only quote
what I found on http://www.linux-usb.org/usb.ids

0846  NetGear, Inc.
	9020  WNA3100(v1) Wireless-N 300 [Broadcom BCM43231]

Gr. AvS

