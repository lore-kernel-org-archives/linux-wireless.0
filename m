Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:41188 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbZKQWG0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 17:06:26 -0500
Subject: Re: [Madwifi-devel] Survey: What are you using MadWifi for, and
 why?
From: Marcel Holtmann <marcel@holtmann.org>
To: David Acker <dacker@roinet.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Andrey Yurovsky <andrey@cozybit.com>,
	Michael Renzmann <mrenzmann@madwifi-project.org>,
	madwifi-devel@lists.sourceforge.net,
	madwifi-users@lists.sourceforge.net,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4B031B48.1090105@roinet.com>
References: <2205.95.222.251.107.1258282369.squirrel@webmail.otaku42.de>
	 <43e72e890911161701p61d0db5ag25a1459f900b3ab7@mail.gmail.com>
	 <4B02DFF4.1060509@roinet.com>
	 <45e8e6c40911171257m7c687380k6e6e2677fd11f851@mail.gmail.com>
	 <43e72e890911171337p4b0d97fcp844266137bb51b56@mail.gmail.com>
	 <4B03193E.2080304@roinet.com>
	 <43e72e890911171345q2dc59d66g6ac2a9eec04c577c@mail.gmail.com>
	 <4B031B48.1090105@roinet.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Nov 2009 23:06:27 +0100
Message-ID: <1258495587.2003.41.camel@violet>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi David,

> The problem with switching to ath5k would be the loss of performance 
> related features (compression, fast frames, turbo), and some required 
> features (half/quarter rates are required for some channels on some 
> radios).  Also, I don't know if ath5k will work on products based on 
> Atheros WiSOCs like Ubiquiti's PicoStation and Bullet.  A lesser issue 
> (more of a pain for me than an ath5k issue) is that I have some 
> platforms that use an older kernel and moving up to a newer kernel will 
> have to be done without hardware vendor support.

and that is exactly not a valid point to include MadWifi into the
staging tree. If you are running older kernels, the staging tree doesn't
help you at all.

Regards

Marcel


