Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:38026 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758121AbbJ3Qmz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2015 12:42:55 -0400
Received: by wmeg8 with SMTP id g8so16225068wme.1
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2015 09:42:54 -0700 (PDT)
MIME-Version: 1.0
From: Pushpal Sidhu <psidhu@gateworks.com>
Date: Fri, 30 Oct 2015 09:36:26 -0700
Message-ID: <CAD1M061nR5s6MFLHtoYDk05Ewz_3SHevB6s7qTB59qz681NLUg@mail.gmail.com> (sfid-20151030_174259_325617_CA383AA0)
Subject: Intel 7260 - limited in 5GHz spectrum
To: linux-wireless@vger.kernel.org
Cc: emmanuel.grumbach@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've been working with the Intel 7260 card which advertises itself as
dual band wireless AC card. However, I cannot get it working in AP
mode in the 5GHz range. An $(iw list) shows that the entire 5GHz band
has 'no IR' next to it so as not to allow device radiation (please see
pastebin here: http://pastebin.com/T4BWnBmn).

After searching around the internet a bit, it seems that the card
doesn't allow for this mode (And is thus not really dual band?). I'd
like to know if this is a firmware limitation and if there's a fix in
place, or if not, why is this card limited to the spectrum it can
radiate at?

Thanks,
- Pushpal
