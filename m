Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:54676 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab1JYSrH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 14:47:07 -0400
Message-ID: <4EA70429.8070505@candelatech.com> (sfid-20111025_204735_044718_5D391E24)
Date: Tue, 25 Oct 2011 11:47:05 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: David Goodenough <david.goodenough@btconnect.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: How to find the phy's associated with a wireless dev
References: <201110251910.37638.david.goodenough@btconnect.com>
In-Reply-To: <201110251910.37638.david.goodenough@btconnect.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/25/2011 11:10 AM, David Goodenough wrote:
> I notice that if I remove the kernel module for a wireless
> interface and reload it, that a new phy is defined.  This is
> confusing my script that sets up interfaces, in particular I
> need to set the distance for a long distance link and that has
> to be done on the phy not the dev.
>
> I am doing this from a script so I guess it has to be a query
> using iw, but I can not see which one to use.

On a recent kernel:
cat /sys/class/net/wlan0/phy80211/name

Thanks,
Ben


>
> David
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

