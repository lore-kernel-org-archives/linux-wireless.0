Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:44100 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932776AbZGPRrB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 13:47:01 -0400
Received: by fxm18 with SMTP id 18so273819fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2009 10:46:59 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 16 Jul 2009 18:46:59 +0100
Message-ID: <3ace41890907161046u1db48eta032356e0af4fea1@mail.gmail.com>
Subject: rfkill backport? crash on suspend on compat-wireless?
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

compat-wireless hasn't been working for a week or two and it was only
a day or two ago it started building again (on an up to date fedora 11
x86_64). Anyway, I have rtl8187 unload on suspend and it has been
working fine for some months (and still do after I removed
<kernel>/update/*). But I had two crashes on suspend while with the
latest compat-wireless, and that's two out of two occasions. I noticed
that now loading rtl8187 (and mac80211, etc) brings in rfkill_backport
- AFAIK it isn't need on my hardware, but... so I guess my question
is, is anybody experiencing crashes on suspend, newly in the last day
or two?

compat-release - master-2009-07-08-3-g3615cdf
master-tag - master-2009-07-10
git-describe - wireless-testing.git - v2.6.31-rc2-27901-ge59c61b

Also crashes on suspend/resume are rather difficult to diagnose (no
display, no log). How do people normally do anything about this kind
of problem?

Hin-Tak
