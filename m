Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:41115 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab2JMJOE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Oct 2012 05:14:04 -0400
Received: by mail-we0-f174.google.com with SMTP id t9so2111477wey.19
        for <linux-wireless@vger.kernel.org>; Sat, 13 Oct 2012 02:14:02 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Mike Schliep <mike.schliep@gmail.com>
Subject: Re: rtl8191su nl80211
Date: Sat, 13 Oct 2012 11:13:58 +0200
Cc: wireless <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Joshua Roys <Joshua.Roys@gtri.gatech.edu>
References: <CAMP=HhVfF863bwN1s0H+qtKEpKh9qBp5F-+9cvXBDCEABsE8gQ@mail.gmail.com> <5078BFA0.7010409@gtri.gatech.edu> <CAMP=HhVkXwYBCGJbiRwWq958Q7b4f6nFoTSHBnuowAnC3S4RuQ@mail.gmail.com>
In-Reply-To: <CAMP=HhVkXwYBCGJbiRwWq958Q7b4f6nFoTSHBnuowAnC3S4RuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201210131113.58711.chunkeey@googlemail.com> (sfid-20121013_111408_727196_C141D64B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 13 October 2012 03:49:10 Mike Schliep wrote:
> I am looking to work on it. I just need a little guidance on what is
> left. Is there documentation on how the rltwifi code works?
I'm no expert since I've just started looking at it.
I've set up a repository over at github with the WIP v2
<https://github.com/chunkeey/rtl8192su> (standalone
driver based on the current rtlwifi driver from wt
plus Joshua's patches)

I'm as far as you. I can get the interface but
rfkill seems to have something against it.
I'm wondering a bit thought about the firmware.
Unlike other rtl8192 devices, it seems to be
some sort of full/soft-mac hybrid. Or what's
this "method 2" I'm reading about, is there
a "method 1" as well?

Regards,
	Chr

Documentation wise: I think the best we have is
the original vendor driver from realtek and
r8712u [although, r8712u's TODO says that it
lacks some "fixes"]. Is this all, or is there
more to be found elsewhere?
