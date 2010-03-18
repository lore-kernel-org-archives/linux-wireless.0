Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:55112 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995Ab0CRTb2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 15:31:28 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: RFC: A workaround for BCM43XX devices with no on-board SPROM
Date: Thu, 18 Mar 2010 20:31:24 +0100
Cc: bcm43xx devel <Bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
References: <4BA266FB.1080507@lwfinger.net>
In-Reply-To: <4BA266FB.1080507@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201003182031.25013.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 18 March 2010 18:46:35 Larry Finger wrote:
> (1) Modify b43-fwcutter to take data from an existing SPROM,

Why not extend the ssb-sprom tool? I don't think this has anything to do with
firmware, except that we (ab)use the firmware loading mechanism of the kernel
for loading the blob into the kernel.

> I have chosen to implement this in
> fwcutter rather than ssb_sprom because the ordinary user will not have access to
> ssb_sprom;

Huh? ssb-sprom is GPL software. I have no problem relicensing it under BSD or
even something more liberal. I don't see a problem for "ordinary users" here.

> however, they do have a version of fwcutter supplied by the distro.

Well, but that version won't do anything on the SPROM, too.

> It it reasonable to keep the vendor portion of the MAC and only replace the
> "serial number", or would it be better to randomize all 6 octants?

I think it doesn't really matter.

-- 
Greetings, Michael.
