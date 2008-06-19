Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:4583 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652AbYFSJT5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2008 05:19:57 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: 802.11 pccard, Agere 0x0156,0x0003?
Date: Thu, 19 Jun 2008 11:19:45 +0200
Cc: Bernhard Reiter <bernhard@intevation.de>
References: <200806181715.20516.bernhard@intevation.de> <1213833799.5258.13.camel@dv> <200806191023.39851.bernhard@intevation.de>
In-Reply-To: <200806191023.39851.bernhard@intevation.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200806191119.45407.hs4233@mail.mn-solutions.de> (sfid-20080619_112005_124627_1C1D984B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> So this is the first indication that the wlags_h2_718 might
> work for the Hermes II card. Where can I download it without
> registration? Why wasn't the 7.22 version used as base for the
> patch?

You can no longer download it, the website has vanished. I 
actually got the filename wrong, the file used to be at

   http://www.agere.com/support/drivers/wl_lkm_718_release.tar.gz

I got the 7.18 driver working with both Hermes I and Hermes II 
cards on 2.4 and 2.6.15 an a PXA255 based embedded device. There 
both H1- and H2-drivers supported WEP+WPA (not WPA2).

I never had success with 7.22 on my embedded device.


For 2.6.25, I only have Hermes II running somewhat, the source 
for this was the Ubuntu-Forum. This one is based on the 
wl_lkm_718_release.tar.gz code, not on 7.22. You can download it 
there only with registration, AFAIK. Did I mention that I don't 
really like forums?



Some of my ancient patches are here:

http://git.openembedded.net/?p=org.openembedded.dev.git;a=tree;f=packages/wlags-modules

(the .bb include the .inc file, which contains the sequence of 
the patches to be applied as well as the #define's to use. In 
the files/ directory are the patches).
