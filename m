Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f224.google.com ([209.85.219.224]:40146 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296AbZFBQem convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 12:34:42 -0400
From: Ivo van Doorn <ivdoorn@gmail.com>
To: alejandro.riveira@gmail.com
Subject: Re: [2.6.27-rc7 vs 2.6.29 Regresion] Wifi Network Slownes rt2500pci
Date: Tue, 2 Jun 2009 18:34:39 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linville@tuxdriver.com, Greg KH <greg@kroah.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
References: <1243247687.5322.8.camel@varda> <1243351397.4888.2.camel@varda> <1243951292.22942.1.camel@varda>
In-Reply-To: <1243951292.22942.1.camel@varda>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200906021834.40009.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 02 June 2009, Alejandro Riveira Fernández wrote:
> El mar, 26-05-2009 a las 17:23 +0200, Alejandro Riveira Fernández
> escribió:
> > El mar, 26-05-2009 a las 14:45 +0200, Ivo van Doorn escribió:
> > > Hi,
> > > 
> > [...]
> > > 
> > > Ok, that means it is the wrong script, try the other one from the download
> > > location you previously refered to. I changed the API some time ago, and
> > > am not sure which stable release that change will be in.
> > 
> > I inline the diff between the two dumps the dumps are attached to the
> > mail message
> 
> ICMP ECHO REQUEST
> 
> Any advance?

Well I checked the dumps from the bugreport, but like I expected
the only difference is that with the slow speed the correct value
is written, and the fast speed the wrong value is written.
I couldn't find anything else interesting in it... :(

Ivo
