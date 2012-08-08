Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1440 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932217Ab2HHPa1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 11:30:27 -0400
Message-ID: <502285F7.8080501@broadcom.com> (sfid-20120808_173030_315451_6E3135CC)
Date: Wed, 8 Aug 2012 17:29:59 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Arliton Rocha" <arliton@gmail.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Problem: BCM 4313 (brcmsmac) always hard blocked
References: <CANZ_KY5-EZ2n54G3P3wnjUdTdVknarnXFK2cj9WobnQemAr5kA@mail.gmail.com>
 <CANZ_KY5yLJrHKQ4c30sNpVXPBRRTzwjyUYREcOaX8YP=OAB=Ew@mail.gmail.com>
In-Reply-To: <CANZ_KY5yLJrHKQ4c30sNpVXPBRRTzwjyUYREcOaX8YP=OAB=Ew@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/08/2012 01:14 PM, Arliton Rocha wrote:
> Hi devs,
> 
> The following card does not work (remains always 'hard blocked'):
>     02:00.0 Network controller [0280]: Broadcom Corporation BCM4313
> 802.11b/g/n Wireless LAN Controller [14e4:4727] (rev 01)
> 
> There is no a physical lock on the notebook in question.
> I know windows can change only by software.
> When i do this, wireless net (and bluetooth) works fine on linux.
> Ok, install windows, unblock... But, why linux can't do this?

Good question and no clear answer. Sorry. Some notebooks have this issue
and it seems dependent on BIOS setting. Maybe you can try your luck at
the notebook manufacturer.

> I have trying a lot of tips about rfkill (unblock all, ...) but
> nothing, remains hard blocked.
> Also i tried, unsuccessfully, map Fn + F12 keys...
> 
> Someone have an idea?
> 
> Hardware information in attachment.
> 
> Thanks in advance.
> Best regards.
> 
> --
> Arliton Rocha
> 

Gr. AvS

