Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:36636 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933949AbZJMUp5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 16:45:57 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Ozan =?utf-8?q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>
Subject: Re: Current status of rt2800usb and staging/rt2870
Date: Tue, 13 Oct 2009 22:44:32 +0200
Cc: linux-wireless@vger.kernel.org,
	"linux-kernel" <linux-kernel@vger.kernel.org>
References: <4AD46380.9020308@pardus.org.tr> <200910131844.58983.bzolnier@gmail.com> <4AD4E60E.5030005@pardus.org.tr>
In-Reply-To: <4AD4E60E.5030005@pardus.org.tr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <200910132244.32835.bzolnier@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 13 October 2009 22:41:50 Ozan Çağlayan wrote:
> Bartlomiej Zolnierkiewicz wrote:
> > Hi,
> >
> > On Tuesday 13 October 2009 13:24:48 Ozan Çağlayan wrote:
> >   
> >> Hi,
> >>
> >> In 2.6.31, there are USB device IDs common between both drivers. Should
> >> a distribution enable both drivers? What do you suggest? Are there any
> >> *known issues* stuff for one of them?
> >>     
> >
> > My advice to distributions for such situations is to ship both but make
> > one driver the default one.  
> 
> By saying to make one driver the default one, you mean avoiding the
> other from getting probed automatically by clearing the device id tables?

Yes but rather using /etc/modprobe.d/blacklist.conf than clearing
id tables so it is easier to switch drivers..
