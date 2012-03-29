Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.polymtl.ca ([132.207.4.11]:33831 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759181Ab2C2M1Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2012 08:27:16 -0400
Received: from localhost (imp-4-2.polymtl.ca [132.207.4.77])
	by smtp.polymtl.ca (8.14.3/8.14.3) with ESMTP id q2TCREL8005478
	for <linux-wireless@vger.kernel.org>; Thu, 29 Mar 2012 08:27:15 -0400
Message-ID: <1333024034.4f74552250426@www.imp.polymtl.ca> (sfid-20120329_142726_310989_63B6D955)
Date: Thu, 29 Mar 2012 08:27:14 -0400
From: Naveen Goswamy <naveen.goswamy@polymtl.ca>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: brcmsmac TCP problems and txop exceeded
References: <1332866581.4f71ee152ce84@www.imp.polymtl.ca> <4F71F3E5.6030105@broadcom.com> <1332870459.4f71fd3bb7453@www.imp.polymtl.ca> <4F74509A.3060103@broadcom.com>
In-Reply-To: <4F74509A.3060103@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For the router, it is a trendnet tew-652brp which uses ath9k drivers.

I can use wireshark.  Do you know what we are looking for, so I can try to
filter for that?

Cheers,

ng

Quoting Arend van Spriel <arend@broadcom.com>:

> On 03/27/2012 07:47 PM, Naveen Goswamy wrote:
> > Hi,
> >
> > The reason I am trying to use wireshark is to try and figure out what is
> going
> > on.  I have strange issues with things like SSH, sshfs, and dynamic
> webpages
> > that involve bidirectional data transfer, like google maps, or even trying
> to
> > send an email through a web-based client.  I also wonder if it might be a
> > setting I am using on my openwrt router, since the behaviour of the driver
> was
> > significantly better the other day when I was on the road and using a
> different
> > network's wireless router.  Disabling WMI modules seemed to help too, but
> not
> > always.  I guess I should try playing with my router again, I did try
> switching
> > channels and using different WPA/WPA2 encryption methods but that didn't
> help.
> > But other wireless clients on the network using different drivers seem to
> work
> > fine.
> >
>
> what hardware are you running the openwrt router firmware on? Can you
> use wireshark to capture what is going over the air.
>
> Gr. AvS
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



