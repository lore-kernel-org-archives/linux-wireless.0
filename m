Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50898 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073Ab1FQOoG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jun 2011 10:44:06 -0400
Received: by bwz15 with SMTP id 15so813308bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jun 2011 07:44:05 -0700 (PDT)
Subject: Re: Status of carl9170
From: Thomas Novin <thomas@xyz.pp.se>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <201106171252.19937.chunkeey@googlemail.com>
References: <1308255196.4264.7.camel@thnov-desktop.xyz.lan>
	 <201106162249.14480.chunkeey@googlemail.com>
	 <1308306023.7789.9.camel@thnov-desktop.xyz.lan>
	 <201106171252.19937.chunkeey@googlemail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 17 Jun 2011 16:44:00 +0200
Message-ID: <1308321840.7789.12.camel@thnov-desktop.xyz.lan> (sfid-20110617_164412_077324_2F24907F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On fre, 2011-06-17 at 12:52 +0200, Christian Lamparter wrote:
> On Friday 17 June 2011 12:20:23 Thomas Novin wrote:
> > On tor, 2011-06-16 at 22:49 +0200, Christian Lamparter wrote:
> > > But at least, you could try to disable the 11n cap by loading the module
> > > with noht=1 and the hwcrypt by nohwcrypt=1.
> > > 
> > > Btw, do you have anything in your dmesg from the driver?
> > 
> > Serious difference! Transferring files both tx/rx with scp at full speed
> > while doing ping results in decent transfer speeds and no packet loss.
> > 
> > From dmesg: http://paste.ubuntu.com/628344/
> Ok, can you please tell which option helped? If it was noht, then
> you should check if there is a newer firmware for your router.

Yes, it was noht that did the trick. Modprobing it with noht=1 and
nohwcrypt=0 I still had the problem.

There isn't any newer AirOS available, what is this about and how can I
describe it to the AP manufacturer if I report it as a bug?

Rgds//Thomas



