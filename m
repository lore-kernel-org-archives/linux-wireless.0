Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56108 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab2AHQFX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jan 2012 11:05:23 -0500
Received: by iaeh11 with SMTP id h11so5461783iae.19
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jan 2012 08:05:23 -0800 (PST)
Message-ID: <4F09BEC0.7080702@lwfinger.net> (sfid-20120108_170527_478155_40AF15E1)
Date: Sun, 08 Jan 2012 10:05:20 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: lina <lina.lastname@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: modprob b43 not work after hilibernate
References: <4F09AAE5.2080209@gmail.com>
In-Reply-To: <4F09AAE5.2080209@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/08/2012 08:40 AM, lina wrote:
> Hi,
>
> after hibernation,
>
> I tried modprob b43 and /etc/initi.d/network-manager restart not work,
>
> is it reboot the only option. ( I googled it seems, not so sure)

Hibernation involves so many parts of the computer that it is hard to tell what 
is happening. If unloading and reloading b43 using modprobe does not help, then 
it is not solely a problem with b43.

You need to provide a better description of what you are doing. Include specific 
output from dmesg and the exact commands you are trying. You should also include 
what distro you are running, your kernel version, and what brand and model of 
computer you are using.

Larry

