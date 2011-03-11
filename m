Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998Ab1CKKWP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2011 05:22:15 -0500
Date: Fri, 11 Mar 2011 11:21:48 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ozan =?utf-8?B?w4dhxJ9sYXlhbg==?= <ozan@pardus.org.tr>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	ivdoorn@gmail.com, Johannes Stezenbach <js@sig21.net>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: Unplugging usb wlan (rt73usb) hangs the system
Message-ID: <20110311102147.GA2275@redhat.com>
References: <4D6E7B55.6010905@pardus.org.tr>
 <20110309100651.GA23594@redhat.com>
 <4D77539A.90300@pardus.org.tr>
 <20110309103633.GB23594@redhat.com>
 <4D79E8E3.7040602@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <4D79E8E3.7040602@pardus.org.tr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 11, 2011 at 11:18:27AM +0200, Ozan Çağlayan wrote:
> 09-03-2011 12:36 tarihinde, Stanislaw Gruszka yazdı:
> >Plese test also that one.
> >commit 070192dd2975c0e97bbdeac7623b755235c6db7d
> >Author: Ivo van Doorn<ivdoorn@gmail.com>
> >Date:   Thu Nov 4 20:41:05 2010 +0100
> >
> >     rt2x00: Fix crash on USB unplug
> >
> 
> OK applied 2 commits on top of 2.6.37.3 and tested with an Edimax
> and an Asus stick, no problem so far.
> But I wonder why are they still in wireless-next? They are quite old
> commits dating from November, shouldn't they already
> be merged to the linux-2.6 tree?
> 
> AFAIK they have to be first applied to linux-2.6 in order to be
> pulled to 2.6.3x.y stable trees.

Both commits are in 2.6.38, I will post them to stable today.
Thanks for reporting and testing!

Stanislaw
