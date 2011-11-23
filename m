Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60314 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755521Ab1KWPv3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Nov 2011 10:51:29 -0500
Received: from public by plane.gmane.org with local (Exim 4.69)
	(envelope-from <public@plane.gmane.org>)
	id 1RTF6c-00044Z-9a
	for linux-wireless@vger.kernel.org; Wed, 23 Nov 2011 16:51:26 +0100
Message-ID: <4ECD1661.2010709@alpha-unix.de> (sfid-20111123_165132_717174_A742C0BA)
Date: Wed, 23 Nov 2011 16:50:57 +0100
From: Michael Basse <michael@alpha-unix.de>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: Stanislaw Gruszka
	<public-sgruszka-H+wXaHxf7aLQT0dZR+AlfA@plane.gmane.org>,
	"John W. Linville"
	<public-linville-2XuSBdqkA4R54TAoqtyWWQ@plane.gmane.org>,
	public-linux-wireless-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org,
	Ivo van Doorn
	<public-IvDoorn-Re5JQEeQqe8AvxtiuMwx3w@plane.gmane.org>,
	Gertjan van Wingerde
	<public-gwingerde-Re5JQEeQqe8AvxtiuMwx3w@plane.gmane.org>,
	Helmut Schaa
	<public-helmut.schaa-gM/Ye1E23mwN+BqQ9rBEUg@plane.gmane.org>,
	Amir Hedayaty
	<public-hedayaty-Re5JQEeQqe8AvxtiuMwx3w@plane.gmane.org>
Subject: Re: [PATCH] rt2800pci: handle spurious interrupts
References: <20111116100915.GA2191@redhat.com> <4ECC071E.5050403@alpha-unix.de> <20111123073500.GA9833@redhat.com>
In-Reply-To: <20111123073500.GA9833@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Hi

Am 23.11.2011 08:35, schrieb Stanislaw Gruszka:
> Hi
> 
> I do not think my patch fix this problem, but perhaps Gertjan's
> patch do this:
> 
> http://marc.info/?l=linux-wireless&m=132112188308082&w=2
> 
> Note, if you are hitting the same issue, what is fixed by this patch,
> it's enough to do "iwconfig wlan0 power off" to workaround the problem.
> So you can avoid applying the patch, and just use above command and
> check if issue is still reproducible.
> 
> Stanislaw

Thank you very much for that feedback. I have posted that informations
on the ubuntu-bugtracker. I will do some testing with that workaround
and hopefully it is fixing the issue.

Greetings

Michael

