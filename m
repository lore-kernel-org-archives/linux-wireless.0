Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1313 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845Ab2C2MID (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2012 08:08:03 -0400
Message-ID: <4F74509A.3060103@broadcom.com> (sfid-20120329_140809_454177_D70280F0)
Date: Thu, 29 Mar 2012 14:07:54 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Naveen Goswamy" <naveen.goswamy@polymtl.ca>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: brcmsmac TCP problems and txop exceeded
References: <1332866581.4f71ee152ce84@www.imp.polymtl.ca>
 <4F71F3E5.6030105@broadcom.com>
 <1332870459.4f71fd3bb7453@www.imp.polymtl.ca>
In-Reply-To: <1332870459.4f71fd3bb7453@www.imp.polymtl.ca>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/27/2012 07:47 PM, Naveen Goswamy wrote:
> Hi,
>
> The reason I am trying to use wireshark is to try and figure out what is going
> on.  I have strange issues with things like SSH, sshfs, and dynamic webpages
> that involve bidirectional data transfer, like google maps, or even trying to
> send an email through a web-based client.  I also wonder if it might be a
> setting I am using on my openwrt router, since the behaviour of the driver was
> significantly better the other day when I was on the road and using a different
> network's wireless router.  Disabling WMI modules seemed to help too, but not
> always.  I guess I should try playing with my router again, I did try switching
> channels and using different WPA/WPA2 encryption methods but that didn't help.
> But other wireless clients on the network using different drivers seem to work
> fine.
>

what hardware are you running the openwrt router firmware on? Can you 
use wireshark to capture what is going over the air.

Gr. AvS

