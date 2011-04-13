Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm4-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.129]:41394 "HELO
	nm4-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932194Ab1DMQLk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 12:11:40 -0400
Message-ID: <677552.47001.qm@web161601.mail.bf1.yahoo.com>
Date: Wed, 13 Apr 2011 09:11:39 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: Re: 2.6.38: rt2800usb: high latency (1000ms)?
To: Justin Piszcz <jpiszcz@lucidpixels.com>,
	Ivo Van Doorn <ivdoorn@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
In-Reply-To: <BANLkTi==Bw6mWWJidLi+ZRzz87ck4DAqVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > I recall using this driver in staging and it crashing
> my machine, now thats
> > its no longer in staging, I thought I'd give it
> another try..  Using the
> 
> The rt2800usb was not in staging but has been inside the
> main kernel
> tree for quite
> some time already, the alternative rt2870sta was in staging
> and will
> be removed very soon.
> 
> > following wireless usb adapter, I'm seeing very high
> latency when using
> > the device in Linux, (with Windows, there are no
> problems).  Using Debian
> > Testing + wpa_supplicant, using the following USB
> adapter:
> 
> Can you try disabling powersaving?
> iwconfig wlan0 power off
> 
> Ivo

Hi,

I have exactly the same device /VID/. Ivo's suggestion fixed the problem, to some extent. Latency is fine now but every now and then I'd get (DUP!) duplicated packets and I've isolated the problem only to 54G capable APs. APs with 11n work fine without duplicate packets (or high latency).

My request is, will you please try pinging both G and N APs to see if duplicate packs are occurring at your end.

Walter
