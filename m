Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749AbaFLMpw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2014 08:45:52 -0400
Date: Thu, 12 Jun 2014 14:44:09 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: Re: Driver for Mediatek MT7630E
Message-ID: <20140612124408.GB7325@redhat.com> (sfid-20140612_144555_635814_71E48CFE)
References: <53987997.2040101@lwfinger.net>
 <CAGXE3d81xMB3Y4WdTBPHKCC91QaieAQd5xzAqWSgGeonbD7_vw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGXE3d81xMB3Y4WdTBPHKCC91QaieAQd5xzAqWSgGeonbD7_vw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 12, 2014 at 09:16:02AM +0200, Helmut Schaa wrote:
> On Wed, Jun 11, 2014 at 5:45 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> > In a recent E-mail interchange
> > (http://marc.info/?l=linux-wireless&m=140238255916367&w=2), I was made aware
> > that this device is not currently being handled by any driver in the kernel,
> > but that there was a GitHub repo at https://github.com/anthonywong/mt7630.
> > That code modifies rt2800pci to operate the MT7630E, but it is quite
> > outdated.
> >
> > As a followup, I found such a device at a reasonable price on E-bay, and
> > ordered it. It should arrive next week. I also was able to find the firmware
> > in an RPM for SUSE SLE11, and a license allowing redistribution. Before I
> > start modifying rt2800pci for this new device, I want to be assured that
> > this modification is not currently being done by anyone in the rt2x00
> > project. There is too much to be done to duplicate effort.
> 
> I'm not doing anything in this regard at the moment. So I'm really glad if you
> are working on that!
> 
> CC'ed Stanislaw even though I don't think he's doing anything regarding the
> device you've mentioned.

Nope, I'm not working on adding support for new chips to rt2x00 at
present nor plan to work on that in the near future, though I have that
on my TODO list :-)

> > For interested readers, I have modified the GitHub code to compile using the
> > current wireless-testing kernel source. If there is sufficient interest, I
> > could set up a new GH repo for it as an interim measure with conditional
> > code allowing it to build on recent kernels (3.5+).

> Awesome news.
+1

Stanislaw 
