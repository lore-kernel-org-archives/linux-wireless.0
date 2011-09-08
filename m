Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46573 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932163Ab1IHDsC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Sep 2011 23:48:02 -0400
Received: by gxk21 with SMTP id 21so630837gxk.5
        for <linux-wireless@vger.kernel.org>; Wed, 07 Sep 2011 20:48:01 -0700 (PDT)
Message-ID: <4E6839A4.9010403@lwfinger.net> (sfid-20110908_054806_762091_76A9E629)
Date: Wed, 07 Sep 2011 22:42:28 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Stefan Zwanenburg <stefanhetzwaantje@gmail.com>
CC: linux-wireless@vger.kernel.org,
	'Chaoming_Li' <chaoming_li@realsil.com.cn>
Subject: Re: RTL8192SE and 802.11n problem
References: <4E67CE3F.8090405@gmail.com> <4E67CEA3.7020709@gmail.com> <4E682732.1040700@lwfinger.net> <4E682D68.1070408@lwfinger.net> <4E68353D.3010505@gmail.com>
In-Reply-To: <4E68353D.3010505@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/07/2011 10:23 PM, Stefan Zwanenburg wrote:
> I cannot. The AP itself (which can display a list of its wireless
> clients including MAC addresses and link type) reports that I'm
> connected over an 802.11g link.
> I'd hate for you to put more time into this if we have indeed
> misunderstood one another.

It is not a matter of "training". If the AP says it is a G connection, then the 
rate will never be more than 54 Mbps.

> Anyway, I'm more than willing to try out the 3.1-rc4 mainline kernel if
> that would be of any help. However, it will have to wait until tomorrow,
> since it's pretty much the end of the night in my timezone, and I have a
> busy day tomorrow. I'll also file a bug report tomorrow, if I haven't
> heard back from you regarding our possible misunderstanding.

I think it may be an incompatibility with that AP, but I will wait for Chaoming 
to check that.

In any case, I would like to know what change increases the rate, thus I'll do 
the bisection.

Larry

