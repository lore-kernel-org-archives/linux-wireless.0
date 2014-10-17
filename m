Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:51664 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbaJQXmi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Oct 2014 19:42:38 -0400
Received: by mail-ig0-f180.google.com with SMTP id uq10so1786446igb.1
        for <linux-wireless@vger.kernel.org>; Fri, 17 Oct 2014 16:42:37 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 18 Oct 2014 01:42:37 +0200
Message-ID: <CACna6ryaj7sGhczjCDBxJVu5buRxhu_A7rQXAdcx2___sWpuBg@mail.gmail.com> (sfid-20141018_014242_340947_912CDF55)
Subject: Documenting AP (and others) mode support
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For a long time I was curious how AP mode is supported in both:
hostapd and cfg80211/mac80211. Unfortunately I wasn't able to find a
straightforward answer. Random info I found was rather confusing,
outdated. For example hostapd wiki page was convincing me I need a
monitor mode interface for hostapd.

So I've slightly updated
http://wireless.kernel.org/en/users/Documentation/hostapd#About_hostapd

And created
http://wireless.kernel.org/en/developers/Documentation/cfg80211/API
(inspired by mac80211/API wiki page)

Of course this is only a beginning, but I don't think I should go
further will my limited knowledge.

So there goes my request: could you review what I've written and
continue my work, if you can? I don't think my description of cfg80211
and AP mode covers much. I'm still not sure about meaning of
WIPHY_FLAG_HAVE_AP_SME (it seems to be important flag for hostapd) and
of course there are mode modes (not just AP) to describe.

P.S.
Another topic I'm interested in is multiple SSIDs support. If someone
could start that, it would be great.

-- 
Rafał
