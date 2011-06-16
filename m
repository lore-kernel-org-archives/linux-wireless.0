Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s126.n241.n6.n64.static.myhostcenter.com ([64.6.241.126]:36910
	"EHLO openvideo.pro" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756792Ab1FPX4D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2011 19:56:03 -0400
Message-ID: <40525.74.64.51.206.1308265716.squirrel@openvideo.pro> (sfid-20110617_015607_443195_559955EC)
Date: Thu, 16 Jun 2011 19:08:36 -0400 (EDT)
Subject: libertas on ETRAX FS / Elphel 353?
From: "George Chriss" <GChriss@openvideo.pro>
To: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm interested in hacking the libertas driver to run on an Axis ETRAX FS
with a heavily-patched 2.6.19 kernel.[1]

It's a discontinued CPU and also a big jump from the >= 2.6.24 kernels
supported by compat-wireless.  However, support for this target would mean
that wireless CompactFlash cards[2] could be used to broadcast live
audio/video wirelessly from Elphel cameras[3].  Current Elphel models are
limited to USB 1.1 (too slow for video) and the only other option that
comes to mind is attaching a wireless router to the Ethernet port.  Newer
Elphel models are unlikely to be released in the near future and it would
take a lot of development effort to update the kernel in current models.

Is libertas support for this embedded system feasible?  I attempted to
build compat-wireless against the Elphel kernel sources and successfully
generated a long list of errors with 'make --keep-going' after commenting
out unnecessary parts of the Makefile.  The build log may be found at [4].


Sincerely,
George


[1] Running code on the ETRAX FS CPU requires use of gcc-cris.
[2] Such as the AmbiCom WL54CF, which powers up and fits nicely into the
Elphel NC353L-369
[3] http://www.elphel.com/353_turnkey
[4] http://is.gd/zFczww

