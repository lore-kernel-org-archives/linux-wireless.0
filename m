Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s87.loopia.se ([194.9.95.110]:25204 "EHLO s87.loopia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676Ab2DIUdL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2012 16:33:11 -0400
Received: from s87.loopia.se (localhost [127.0.0.1])
	by s87.loopia.se (Postfix) with ESMTP id 7791A1E1F158
	for <linux-wireless@vger.kernel.org>; Mon,  9 Apr 2012 22:33:07 +0200 (CEST)
Received: from s87.loopia.se ([127.0.0.1])
	by s87.loopia.se (s87.loopia.se [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id Tsgint2EM-33 for <linux-wireless@vger.kernel.org>;
	Mon,  9 Apr 2012 22:33:04 +0200 (CEST)
Received: from s331.loopia.se (s34.loopia.se [194.9.94.70])
	by s87.loopia.se (Postfix) with ESMTP id 86B331E1F18D
	for <linux-wireless@vger.kernel.org>; Mon,  9 Apr 2012 22:32:37 +0200 (CEST)
From: Jan Simonson <jan@simonson.se>
To: "John W. Linville" <linville@tuxdriver.com>
Reply-To: Jan Simonson <jan@simonson.se>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: RTL8192e-pci NIC
Date: Mon, 09 Apr 2012 22:32:36 +0200
Message-ID: <1458082.uKdUEMMXD6@ymer> (sfid-20120409_223316_000060_1374FA40)
In-Reply-To: <20120409192630.GB26994@tuxdriver.com>
References: <1502184.lhzNHmlX61@ymer> <4F8306CF.4040503@lwfinger.net> <20120409192630.GB26994@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

måndagen den 9 april 2012 15.26.30 skrev du:
> On Mon, Apr 09, 2012 at 10:57:03AM -0500, Larry Finger wrote:
> > As I do not use Fedora, I was not aware of Fusion. Perhaps you could
> > get them to reinstate this driver in their package. In addition, you
> > might post a bug at Redhat in hopes that they will change their
> > standard configuration. As a last resort, you could switch to a
> > distro that includes this driver in their standard kernels.

Actually I managed to load the modules and wlan0 shows up. (I follwed your 
advice to use the same Fedora kernel and run depmod). Unfortunately I'm still 
unable to connect to any network with or without encryption.

> Yeah, this is reasonable advice.  I don't know why Fusion droped this
> package, but it might have been due to me making their life harder by
> integrating compat-wireless directly into the Fedora kernels.  Since I
> am no longer doing that, they may be willing to reverse that decision.

I filed this bug http://bugzilla.rpmfusion.org/show_bug.cgi?id=2265 with Fusion 
in case they were not aware of the two versions.

> I don't really see including a staging driver in Fedora unless it is
> clearly on the path to the "normal" part of the kernel.  Any chance
> of that?

The TODO-file in kernel-3.3.fc16/linux-3.3.x86_64/drivers/staging/rtl8192e/ 
reads:

* merge into drivers/net/wireless/rtllib/rtl8192e
* clean up function naming

But when is, of course, another question.

Jan
