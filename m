Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f47.google.com ([209.85.219.47]:33940 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755961Ab3FRP0f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 11:26:35 -0400
Received: by mail-oa0-f47.google.com with SMTP id m1so5260708oag.34
        for <linux-wireless@vger.kernel.org>; Tue, 18 Jun 2013 08:26:34 -0700 (PDT)
Message-ID: <51C07C29.6070602@lwfinger.net> (sfid-20130618_172649_475423_18E50FBF)
Date: Tue, 18 Jun 2013 10:26:33 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Paul Menzel <paulepanter@users.sourceforge.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: Connection not established with Realtek RTL8188CUS based USB
 device (EDIMAX)
References: <1371326265.9845.54.camel@mattotaupa>  <51BCD7BA.1040900@lwfinger.net> <1371505124.8902.72.camel@mattotaupa>  <51BF8B8D.3030603@lwfinger.net> <1371542085.7163.15.camel@mattotaupa>
In-Reply-To: <1371542085.7163.15.camel@mattotaupa>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/18/2013 02:54 AM, Paul Menzel wrote:
> Three more questions regarding this patch.
>
> 1. Could you add `CC: stable@vger.kernel.org` to the patch so it gets
> backported to the stable Linux kernel releases.

I thought I had done that. In fact, the patch was Cc'd to stable, but I missed 
the entry in the commit message. I have written to Stable to see what caqn be done.

> 2. Does this fix a regression or did it never work with WEP/WPA(1)
> networks before?

It does fix a regression, but I have no idea when it happened.

> 3. If wpa_supplicant only prints WPA to `/var/log/syslog`, can I be sure
> this is *no* WPA2 network? Because I always thought this is a WPA2
> network.

The data in an "iwlist scan" will state the version of WPA in use. If it is 
WPA2, you get a line with

IE: IEEE 802.11i/WPA2 Version 1

For WPA1, it is

IE: WPA Version 1

Larry



