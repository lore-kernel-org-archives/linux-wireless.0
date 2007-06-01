Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:53418 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760792AbXFAS6G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2007 14:58:06 -0400
Message-ID: <46606C38.8090103@lwfinger.net>
Date: Fri, 01 Jun 2007 13:58:00 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: "John H." <mistamaila@gmail.com>
CC: Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Upgrade to f7 breaks bcm43xx module
References: <5b9417770706011111u20f32192s960961dc8693f00e@mail.gmail.com>	 <4660630E.7040701@lwfinger.net> <5b9417770706011123s3a54c43ep69257321e8102719@mail.gmail.com>
In-Reply-To: <5b9417770706011123s3a54c43ep69257321e8102719@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John H. wrote:
> Thanks for the prompt response.
> 
> I have a dell e1505.  Do I need an updated fwcutter as well?  What is
> the actual driver I need?  The device is broadcom 1390?

I missed one keyword in my message - you need a V4 Windows or OS X driver. I use wl_apsta.o, but 
that driver occurs in both V3 and V4 versions. The Windows driver would be named bcmwl5.sys, but 
they usually come with a lot of other Windows software bundled in. Check the archives for a URL for 
the V4 variety of wl_apsta.o

The fc7 version of fwcutter should handle the driver.

Larry



