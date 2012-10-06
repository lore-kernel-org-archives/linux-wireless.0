Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:30406 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab2JFWeV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Oct 2012 18:34:21 -0400
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: OpenFWWF for b43
Date: Sun, 7 Oct 2012 00:34:05 +0200
Cc: Rami Rosen <roszenrami@gmail.com>,
	"Mikko V. =?iso-8859-1?q?Viinam=E4ki?="
	<Mikko.Viinamaki@students.turkuamk.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Michael =?iso-8859-1?q?B=FCsch?= <m@bues.ch>
References: <0C7D424D957547489E16A29D0D15433494C29E7FE8@AMKMS11.ad.turkuamk.fi> <CAKoUArnsntysudq3CRric4gb3eUOLq2f9ppkUGxbqWhSZp7yhg@mail.gmail.com> <5070944B.4010205@lwfinger.net>
In-Reply-To: <5070944B.4010205@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201210070034.13343.s.L-H@gmx.de> (sfid-20121007_003431_070012_104CBC49)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Saturday 06 October 2012, Larry Finger wrote:
> On 10/06/2012 02:15 PM, Rami Rosen wrote:
> > Hi,
> > - Thanks ! good news !
> >
> > The link to b43-tools seems to be broken.
> >
> > This failed:
> > git clone http://git.bu3sch.de/git/b43-tools.git
> >
> > The b43_v4.6.tar.gz can be downloaded
> > (BTW, when running tar xfz  b43_v4.6.tar.gz,
> > am empty  file named b43_v4.6.tar.gz is created inside
> > b43_v4.6/ folder)
> 
> That repo was converted from HTTP to GIT form some time ago. The correct request is
> 
> git clone git://git.bu3sch.de/git/b43-tools.git
> 
> It appears, however, the git.bu3sch.de is down.

It's 
	http://git.bues.ch/gitweb
	http://git.bues.ch/gitweb?p=b43-ucode.git;a=summary
	git://git.bues.ch/b43-ucode.git
these days.

However it's a predecessor to OpenFWWF and not the working repository 
for it, which unfortunately doesn't seem to be maintained in a public 
repository.

Regards
	Stefan Lippers-Hollmann
