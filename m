Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:37729 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab1EFNSp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 09:18:45 -0400
Received: by vxi39 with SMTP id 39so3416501vxi.19
        for <linux-wireless@vger.kernel.org>; Fri, 06 May 2011 06:18:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110506081356.08ac93a8@tomh>
References: <20110506081356.08ac93a8@tomh>
Date: Fri, 6 May 2011 15:18:44 +0200
Message-ID: <BANLkTi=R_4-OgRbq+5Mi3Cyv4nNJE8RPQQ@mail.gmail.com> (sfid-20110506_151849_036215_EE6DED6F)
Subject: Re: r8192cu AP mode?
From: Juan Carlos Garza <juancarlosgarza@gmail.com>
To: Tom Horsley <horsley1953@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Fri, May 6, 2011 at 2:13 PM, Tom Horsley <horsley1953@gmail.com> wrote:
> I recently got a cheap usb wi-fi dongle I would love to get
> working as an access point. I see the driver table on
> the linux wireless website has question marks on most
> of the columns in the row for the r8192cu. Anything I
> can do to help fill in "yes" in those columns?

The required functionality for Access Points is not yet implemented in
the mac80211 driver for the rtl8192cu chipset.

>
> Here's my experience and findings so far:
>
> http://home.comcast.net/~tomhorsley/hardware/rtl8192cu/rtl8192cu.html
>
> I'm currently working on fedora 14 with the 2.6.35
> kernel fedora ships. Might I have more luck with a
> later kernel.org kernel?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
Juan Carlos Garza
