Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40961 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757966Ab1GKP5Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2011 11:57:24 -0400
Received: by vws1 with SMTP id 1so2799849vws.19
        for <linux-wireless@vger.kernel.org>; Mon, 11 Jul 2011 08:57:23 -0700 (PDT)
Message-ID: <4E1B1D60.9030509@lwfinger.net> (sfid-20110711_175728_428665_3D0A41B1)
Date: Mon, 11 Jul 2011 10:57:20 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Ali Bahar <ali@internetdog.org>
CC: linux-wireless@vger.kernel.org, WLAN FAE <wlanfae@realtek.com>
Subject: Re: [PATCH 0/2] staging: r8712u: Set ESSID/AP now possible before
 interface is brought Up.
References: <1310378876-1311-1-git-send-email-ali@internetDog.org>
In-Reply-To: <1310378876-1311-1-git-send-email-ali@internetDog.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/11/2011 05:07 AM, Ali Bahar wrote:
> These are updates to how the 'bup' flag is handled. The first allows Sets
> before the interface is brought Up, and the second is housekeeping of the
> flag's value when the interface is taken Down.
>
> Ali Bahar (2):
>    staging: r8712u: Sets to SSID, and to AP MAC#, can now be done
>      when the interface is Down.
>    staging: r8712u: Interface-state not fully tracked.
>
>   drivers/staging/rtl8712/drv_types.h           |    5 +++++
>   drivers/staging/rtl8712/os_intfs.c            |   14 ++++++++++++++
>   drivers/staging/rtl8712/rtl871x_ioctl_linux.c |   25 +++++++++++++++++++++----
>   3 files changed, 40 insertions(+), 4 deletions(-)
>

Ali,

The patches look good, except for one problem. As this driver is in staging, the 
patches need to be sent to Greg Kroah-Hartman <gregkh@suse.de>, not through 
linux-wireless.

One other point - for those patches that are properly sent through wireless, 
John Linville should be the one to receive those. He is the maintainer for that 
section, just as GregKH is the maintainer for staging.

Larry

