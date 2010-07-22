Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34815 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab0GVFHY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 01:07:24 -0400
Received: by yxg6 with SMTP id 6so309718yxg.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Jul 2010 22:07:23 -0700 (PDT)
MIME-Version: 1.0
From: Jonathan Guerin <jonathan@guerin.id.au>
Date: Thu, 22 Jul 2010 14:55:36 +1000
Message-ID: <AANLkTimWWGlhEhIRol_5kjhIIEILLgDuMmUXUHCCVUC1@mail.gmail.com>
Subject: ath5k debug mode
To: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I'm not sure if I'm just misunderstanding something, or if they
documentation is older than what's happening in practice. I'm trying
to enable ath5k debug mode so that I can have a poke around in debufs.

Unfortunately, enabling debug in the compat-wireless distro doesn't
seem to output the same information as I've been reading about
elsewhere on the 'net. My understanding is that ath5k should load an
ath5k directory tree into debugfs:
http://www.mail-archive.com/ath5k-devel@lists.ath5k.org/msg00266.html

This doesn't seem to be happening at the moment - what I CAN see in
the /debug tree is:
bdi  gpio  ieee80211  kprobes  mce  pktcdvd  sched_features  tracing  usb  x86

Some of the stuff I expect to see in ath5k is in ieee8022, but I
cannot write to this tree. Trying to replicate the cat mentioned in
the link above to set the debug level in this tree fails with a
'permission denied' error.

Trying to load the module with the debug param fails with the following error:
ath5k: Unknown parameter `debug'

I'm wondering if someone would be able to point me in the right
direction to get this working.

Your help would be greatly appreciated!

Thanks,

--
Jonathan Guerin
