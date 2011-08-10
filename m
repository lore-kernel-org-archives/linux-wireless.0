Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44768 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455Ab1HJL7Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 07:59:24 -0400
Received: by yxj19 with SMTP id 19so591622yxj.19
        for <linux-wireless@vger.kernel.org>; Wed, 10 Aug 2011 04:59:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20110810T133554-589@post.gmane.org>
References: <loom.20110810T133554-589@post.gmane.org>
From: Arik Nemtsov <anamtsov@gmail.com>
Date: Wed, 10 Aug 2011 14:59:09 +0300
Message-ID: <CA+XVXfeaz+44f-X5vcWSpuBh-XNeK99bvzg_wXJJDpOs1=nF1A@mail.gmail.com> (sfid-20110810_135928_225415_9E9AE10F)
Subject: Re: Problem bringing up wlan0 interface up with mainline wl1271
 drivers on Panda Board with 2.6.39 Kernel
To: "amit.gemini@sasken.com" <amit.gemini@sasken.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey Amit,

On Wed, Aug 10, 2011 at 14:38, amit.gemini@sasken.com
<amit.gemini@sasken.com> wrote:
> I am using Panda Board with 2.6.39 Kernel
>
> when ever i insert the driver , error comes out "wl1271: ERROR could not get nvs
> file: -2"
>

You should put a NVS file in the same folder as your FW file. You can
read more about it in
http://linuxwireless.org/en/users/Drivers/wl12xx.

If you're having further issues we're on IRC - #wl12xx on freenode.

Arik
