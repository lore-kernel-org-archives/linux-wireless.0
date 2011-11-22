Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:58143 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755854Ab1KVUfG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 15:35:06 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1RSx3Y-0000Fz-Gs
	for linux-wireless@vger.kernel.org; Tue, 22 Nov 2011 21:35:04 +0100
Received: from p5791742e.dip0.t-ipconnect.de ([87.145.116.46])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 22 Nov 2011 21:35:04 +0100
Received: from michael by p5791742e.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 22 Nov 2011 21:35:04 +0100
To: linux-wireless@vger.kernel.org
From: Michael Basse <michael@alpha-unix.de>
Subject: Re: [PATCH] rt2800pci: handle spurious interrupts
Date: Tue, 22 Nov 2011 21:33:34 +0100
Message-ID: <4ECC071E.5050403@alpha-unix.de> (sfid-20111122_213516_384831_A026761E)
References: <20111116100915.GA2191@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "John W. Linville"
	<public-linville-2XuSBdqkA4R54TAoqtyWWQ@lo.gmane.org>,
	public-linux-wireless-u79uwXL29TY76Z2rM5mHXA@lo.gmane.org,
	Ivo van Doorn
	<public-IvDoorn-Re5JQEeQqe8AvxtiuMwx3w@lo.gmane.org>,
	Gertjan van Wingerde
	<public-gwingerde-Re5JQEeQqe8AvxtiuMwx3w@lo.gmane.org>,
	Helmut Schaa
	<public-helmut.schaa-gM/Ye1E23mwN+BqQ9rBEUg@lo.gmane.org>,
	Amir Hedayaty
	<public-hedayaty-Re5JQEeQqe8AvxtiuMwx3w@lo.gmane.org>
In-Reply-To: <20111116100915.GA2191@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Stanislaw,
first of all thank you for your patch.

> I changed rt2800pci only because get bug report for that device,
> not sure if similar changes are not needed for other rt2x00 PCI
> devices

Me (and many other) ubuntu-users are facing issues with different
Version of Kernel 3.x. As it seems all users are using "rt2800pci" for
there wifi.

Model: "RaLink RT2860"
Vendor: pci 0x1814 "RaLink"
Device: pci 0x0781 "RT2860"
SubVendor: pci 0x1814 "RaLink"
SubDevice: pci 0x2790
Driver: "rt2800pci"
Driver Modules: "rt2800pci"

See also

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/869502
http://thread.gmane.org/gmane.linux.kernel/1211290
http://rt2x00.serialmonkey.com/phpBB/viewtopic.php?f=5&t=6192

I have build the newest ubuntu-kernel with your patch

http://alpha-unix.de/~iceroot/ubuntu/

Hopefully your patch is fixing the issues we are facing.
Just wanted to say thank you to your work and i will give you feedback
about your patch.

Greetings from germany

Michael Basse
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJOzAcdAAoJEMIajL8dFT4GAXwIAJJJoUghmTUbw/354z09CDuB
eCpIaJw0is+zyp3RLssUJmmabyFtLkC0nFJ4iAGJfL/ozf7ISjtk1nLlQFbt6/iy
knV1uSGv6o9UuFCzJZ7boJ9cdNq35pAVul86PFqQ+fgDQYdlqfdLyNc71JRazvIE
b01jUudgjZDe09rKmrxiBvcr7FVKPhsSvrH5t6mSYpHJufDDm+TmQk+TJBT+KS8/
aDMPKXlCaAXNlXlm8tgLds8Flx5nnxGvvSXA1DDw37Z7kHOWKLOeHz8ILuctneVz
e8Fp5kgl02VVUVFK/K6+M4EbF/jmTo7FIW5Nlv60H9qsfx+peTkhKqx8o48FGAQ=
=D2BU
-----END PGP SIGNATURE-----

