Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753502Ab3CCQIN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Mar 2013 11:08:13 -0500
Message-ID: <1362326921.1832.41.camel@dcbw.foobar.com> (sfid-20130303_170817_707074_8AA68482)
Subject: Re: Fwd: Intel Wifilink 5100 AGN - Does it support Access Point
 Infrastructure Mode ?
From: Dan Williams <dcbw@redhat.com>
To: Abdelmuhaimen Seaudi <aseaudi@gmail.com>
Cc: Pat Erley <pat-lkml@erley.org>, linux-wireless@vger.kernel.org
Date: Sun, 03 Mar 2013 10:08:41 -0600
In-Reply-To: <CABFmVg4_-fjU1iKaqTCYZKeMe7QKKvXCgcMuB6jx+D4mzQ_F6Q@mail.gmail.com>
References: <CABFmVg5sPub5Q4n+7PnkUn7weQLEUabONeJQZY6aFS2yFZAf2Q@mail.gmail.com>
	 <CABFmVg5AaTG-F_myEA=WGdYpnwN9X=QfLcjKvwJ1-SUX0quaOg@mail.gmail.com>
	 <CABFmVg5J6nWfBFL1VAsD+V3X_xPD6v4wLz0X5Wv4p082Trdshw@mail.gmail.com>
	 <5131D400.3070506@erley.org>
	 <CABFmVg4_-fjU1iKaqTCYZKeMe7QKKvXCgcMuB6jx+D4mzQ_F6Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-03-02 at 14:47 +0200, Abdelmuhaimen Seaudi wrote:
> Hello Pat,
> So this means no way the Intel WiFiLink 5100 AGN will run in AP master
> mode, correct ?

Correct.  If the 'iw' command does not report "AP" mode, then that mode
is not supported by the firmware and kernel version that you are
running.  AFAIK, the 51xx does not now and will not support AP mode on
Linux in the future.

Dan

> Note that it can run in Windows using program like Virtual Router, and
> I confirmed I was able to connect to my workstation wifi. Note also
> that it is not using Adhoc mode, it was using AP Infrastructure mode.
> Thanks for your confirmation.
> 
> On 3/2/13, Pat Erley <pat-lkml@erley.org> wrote:
> > On 03/02/2013 04:51 AM, Abdelmuhaimen Seaudi wrote:
> >> Hello iwlwifi support,
> >> I want to run my Wifi Intel WifiLink 5100 AGN in Access Point
> >> Infrstructure Mode, so that I can connect via WiFi with other devices
> >> to my workstation.
> >> This is under Ubuntu Linux 12.10.
> >> I have tried setting the wlan0 to run in master mode, but it gives me
> >> error, as shown below.
> >> Is it possible to run this WiFi radio in AP Infrstrucutre mode ? How ?
> >> Thanks,
> >>
> >
> > <SNIP>
> >
> >> 	Supported interface modes:
> >> 		 * IBSS
> >> 		 * managed
> >> 		 * monitor
> >> 	software interface modes (can always be added):
> >> 		 * monitor
> >
> > It also looks like this chipset doesn't support master mode.
> >
> > Pat Erley
> >
> 
> 


