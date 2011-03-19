Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web161615.mail.bf1.yahoo.com ([98.139.211.137]:47076 "HELO
	web161615.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750985Ab1CSXce convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Mar 2011 19:32:34 -0400
Message-ID: <625424.27965.qm@web161615.mail.bf1.yahoo.com>
Date: Sat, 19 Mar 2011 16:32:32 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: Re: Bug#618930: High network latency with ralink usb wireless device
To: Richard Kettlewell <rjk@greenend.org.uk>,
	Johannes Stezenbach <js@sig21.net>
Cc: linux-wireless@vger.kernel.org, 618930@bugs.debian.org,
	Ivo Van Doorn <ivdoorn@gmail.com>
In-Reply-To: <20110319223159.GA19576@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> 
> I sent a patch to disable power save by default, but then
> work started
> to fix it instead, but then stalled.  Seems like
> 2.6.38 shipped with
> broken power save enabled by default.  Plese read the
> discussion
> following my RFC patch:
> http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2011-January/thread.html#3017
> 
> You can test if power saving causes your issue by
> disabling
> it with "iwconfig wlan0 power off".
> 

Hi Johannes

Does this patch touches on lost and duplicate packets with rt3070 USB as well?

Walter


      
