Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from postler.einfach.org ([86.59.21.13]:52882 "EHLO
	postler.einfach.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757857Ab3DYVgM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Apr 2013 17:36:12 -0400
Message-ID: <5179A1C6.2060600@einfach.org> (sfid-20130425_233617_582863_892F3D8E)
Date: Thu, 25 Apr 2013 22:36:06 +0100
From: Bruno Randolf <br1@einfach.org>
MIME-Version: 1.0
To: Franky Lin <frankyl@broadcom.com>
CC: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org, meuleman@broadcom.com,
	brudley@broadcom.com, brcm80211-dev-list@broadcom.com,
	=?UTF-8?B?5rW36Je7?= =?UTF-8?B?5pWs5LmL?= <tkaiso@thinktube.com>
Subject: Re: Broadcom brcmfmac vs bcmdhd on Android
References: <5176ABB1.2070506@einfach.org> <5176F8C2.7050502@broadcom.com> <5177F7D6.2020800@einfach.org> <51797866.9030403@einfach.org> <51799C33.7040109@broadcom.com>
In-Reply-To: <51799C33.7040109@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/25/2013 10:12 PM, Franky Lin wrote:
> It looks like the device is not powered up. Do you see the wifi chip get
> enumerated by SDIO bus? There should be something like mmc0:0001:1 under
> /sys/bus/sdio/devices

No, /sys/bus/sdio/devices is empty. How can I power it up? Any reference 
in bcmdhd?

bruno


