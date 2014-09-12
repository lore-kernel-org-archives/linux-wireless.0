Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:42085 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbaILKYA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2014 06:24:00 -0400
Message-ID: <5412C9BD.8010102@broadcom.com> (sfid-20140912_122405_235825_041F4AE1)
Date: Fri, 12 Sep 2014 12:23:57 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Qiang He <billyhq@gmail.com>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: full mac driver supporting monitor mode
References: <CAPb0m=+gSGv0gJDn_EZwwxRCv9zFtSZbmmkG5E42+H3zRrbfdA@mail.gmail.com>
In-Reply-To: <CAPb0m=+gSGv0gJDn_EZwwxRCv9zFtSZbmmkG5E42+H3zRrbfdA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/12/14 01:47, Qiang He wrote:
> Hi Arend,
> I get information from
> http://wireless.kernel.org/en/users/Drivers/brcm80211 that monitor mode
> for full mac driver will added in the future.
>
>
> /"To be done for fullmac driver
>
> Add support for
>
> debugfs (for accessing counters and other diagnostic info)
> monitor mode
> Add support for more chips."/
>
> Does this have a schedule or is there any information about monitor mode
> before released?

Main part of the work is in firmware. I did some investigation on this a 
while ago and started on firmware changes for it. However, that work 
went in the drawer, but there seems to be other picking up the task. I 
do not have enough info to give a timeline here.

Regards,
Arend
