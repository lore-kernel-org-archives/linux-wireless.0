Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f228.google.com ([209.85.218.228]:35104 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933346AbZGPUwD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 16:52:03 -0400
Received: by bwz28 with SMTP id 28so367800bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2009 13:52:02 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC/RFT 5/5] mac80211: implement basic background scanning
Date: Thu, 16 Jul 2009 22:52:09 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>
References: <200907161104.41975.helmut.schaa@gmail.com> <200907161150.54237.helmut.schaa@gmail.com> <1247739394.29762.9.camel@johannes.local>
In-Reply-To: <1247739394.29762.9.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200907162252.09504.helmut.schaa@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Donnerstag, 16. Juli 2009 schrieb Johannes Berg:
> On Thu, 2009-07-16 at 11:50 +0200, Helmut Schaa wrote:
> > I didn't do much performance testing, just a single wget and the performance
> > dropped to about 50%. I still have to run some iperf tests (both RX and TX) to
> > see how it behaves.
> 
> I'd be more interested in the rtt stats that ping -f prints after you
> abort it:
> 
> rtt min/avg/max/mdev = 0.021/0.028/1.726/0.051 ms

JFI, here's the result:

30851 packets transmitted, 30796 received, 0% packet loss, time 80592ms
rtt min/avg/max/mdev = 1.512/8.235/251.145/32.479 ms, pipe 12, ipg/ewma 2.612/1.709 ms

Helmut
