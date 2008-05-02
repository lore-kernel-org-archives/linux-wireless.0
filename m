Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:33332 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755072AbYEBVU1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 May 2008 17:20:27 -0400
Received: by ug-out-1314.google.com with SMTP id h3so146765ugf.16
        for <linux-wireless@vger.kernel.org>; Fri, 02 May 2008 14:20:23 -0700 (PDT)
To: Scott White <nwi_sub@hotmail.com>
Subject: Re: Please pull 'upstream' branch of rt2x00
Date: Fri, 2 May 2008 23:25:38 +0200
Cc: linux-wireless@vger.kernel.org
References: <BAY113-W31BC1B2DB0F0597B99310784DA0@phx.gbl>
In-Reply-To: <BAY113-W31BC1B2DB0F0597B99310784DA0@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200805022325.38311.IvDoorn@gmail.com> (sfid-20080502_232004_497703_1C3E5BAD)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 02 May 2008, Scott White wrote:
> 
> >Was this patch series in time for the 2.6.26 merge window?
> >
> >If not, please consider merging at least the following patches since
> >they are real bugfixes:
> >
> >>       rt2x00: Don't enable short preamble for 1MBs
> >>       rt2x00: Fix quality/activity led handling
> >>       rt2x00: Clarify supported chipsets in Kconfig
> >
> >The others are code cleanups which are "nice to have", but could otherwise
> >wait for 2.6.27.
> 
> The merge window is still open at this time.  I haven't seen a rc1 yet.  Anyway I saw that only the 3 bugfixes are currently in the queue.  As the owner of several (10 by the university and 2 personal) rt73 usb wireless cards, I would really like it if the latest version 2.1.5 made into 2.6.26.  As someone who has used 2.6.24 and finished compiling 2.6.25 two days ago I find that the driver in both kernels is not good.  Not good means I get a wireless signal and I get data transfers, but the speed fluctuates and have other issues.  However with each release, the problems I have are slowing decreasing.  I have been waiting patiently for 2.6.25-rc1 to have 2.1.5 since 2.1.5 was announced.  I really think all of 2.1.5 should get in 2.6.25-rc1.

Have you tried forcing the rate to 54Mbit instead of letting the rate selection algorithm doing its work?
It seems to have helped with several other users.

Ivo
