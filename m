Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:39647 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754963AbZAIKQl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 05:16:41 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: Thoughts about the b43 RNG
Date: Fri, 9 Jan 2009 11:15:22 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <200901090211.03937.mb@bu3sch.de> <1231464519.5715.32.camel@brick> <1231464656.5715.33.camel@brick>
In-Reply-To: <1231464656.5715.33.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200901091115.22375.mb@bu3sch.de> (sfid-20090109_111647_139080_2F839348)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 09 January 2009 02:30:56 Harvey Harrison wrote:
> On Thu, 2009-01-08 at 17:28 -0800, Harvey Harrison wrote:
> > On Fri, 2009-01-09 at 02:11 +0100, Michael Buesch wrote:
> > > I was doing some random tests on the b43 hardware RNG.
> > > These are the results.
> > > 
> > > I patched the firmware to not access the RNG register anymore.
> > > The unpatched firmware does two things. It reads the RNG register to get random values
> > > and it writes 0 to the register every now and then for whatever reason.
> > > Both reads and writes were patched out during my test. So the driver was
> > > the only one accessing the RNG.
> > > 
> > > This is the result of reading a few bytes from the RNG with the patched fw:
> > 
> > > I'm not sure about this. There aren't any obvious patterns.
> > > But maybe I'm just blind. Does somebody else see some pattern or
> > > has some RNG test program to recognize such patterns?
> > > 
> > > So let's do another test. Let's modify the previous test to
> > > write 0xFFFF instead of 0:
> > > 
> > 
> > NIST has a pretty good test suite I think.
> 
> Packaged for debian as dieharder if you want the command-line version.

Thanks. I didn't know it was already packaged. So I'll certainly try it.

-- 
Greetings, Michael.
