Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54991 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755371Ab1EFPAA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 11:00:00 -0400
Received: by pvg12 with SMTP id 12so1461420pvg.19
        for <linux-wireless@vger.kernel.org>; Fri, 06 May 2011 08:00:00 -0700 (PDT)
Message-ID: <4DC40CEB.5010107@lwfinger.net> (sfid-20110506_170011_439302_847408E4)
Date: Fri, 06 May 2011 09:59:55 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Tom Horsley <horsley1953@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: r8192cu AP mode?
References: <20110506081356.08ac93a8@tomh>
In-Reply-To: <20110506081356.08ac93a8@tomh>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/06/2011 07:13 AM, Tom Horsley wrote:
> I recently got a cheap usb wi-fi dongle I would love to get
> working as an access point. I see the driver table on
> the linux wireless website has question marks on most
> of the columns in the row for the r8192cu. Anything I
> can do to help fill in "yes" in those columns?
>
> Here's my experience and findings so far:
>
> http://home.comcast.net/~tomhorsley/hardware/rtl8192cu/rtl8192cu.html
>
> I'm currently working on fedora 14 with the 2.6.35
> kernel fedora ships. Might I have more luck with a
> later kernel.org kernel?

You don't necessarily need a newer kernel, just install the compat-wireless 
package. I'm not a Fedora user, so I don't know the exact details, but I'm 
reasonably certain one exists. If not, you can always get the compat-wireless 
sources from http://wireless.kernel.org/en/users/Download.

The Linux driver for this chip is rtl8192cu and it became part of the mainline 
kernel with 2.6.39, which is the current mainline kernel and at 2.6.39-rc6. As 
it is not yet "stable", you might not want to run it, but the package noted 
above will have the same code for this device.

Larry
