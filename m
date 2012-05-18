Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44821 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041Ab2EREvO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2012 00:51:14 -0400
Received: by lbbgm6 with SMTP id gm6so1794891lbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 May 2012 21:51:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <69fa4f807ccd8b754ec80307e60e8ab8.squirrel@magitekindustries.com>
References: <6x75xpmamff1htgn6m1n6t9l.1337272291919@email.android.com>
 <CAGRGNgVnHwFH99xDn_OG93OerJRK8QzYacm-JwhxXjdmwCC2UA@mail.gmail.com>
 <4FB5ADAB.5010206@Magitekindustries.com> <CAGRGNgUc=bi9vOfukw_uBRH7TD=wYcFJ1yEPVLiFfAw8cK_-9g@mail.gmail.com>
 <69fa4f807ccd8b754ec80307e60e8ab8.squirrel@magitekindustries.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 18 May 2012 14:50:52 +1000
Message-ID: <CAGRGNgV2W3ui=UR759ZBAFisapzDuc13GkG5k2L055etG+NoHg@mail.gmail.com> (sfid-20120518_065117_592336_B3C2833D)
Subject: Re: Intel 2200BG/Linux
To: dc@magitekindustries.com
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Fri, May 18, 2012 at 2:35 PM,  <dc@magitekindustries.com> wrote:
> [ 18.522100] ipw2200: Unable to load firmware: -2

You do not have the firmware installed.

Your distro should have a package called "firmware-ipw2x00" that you
can install. This package will set it all up automatically.

Otherwise, unpacking the firmware to /lib/firmware should fix your problem.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
