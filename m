Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:42444 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab1GDVHA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jul 2011 17:07:00 -0400
Received: by fxd18 with SMTP id 18so5553739fxd.11
        for <linux-wireless@vger.kernel.org>; Mon, 04 Jul 2011 14:06:58 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Alex <alex9434@gmail.com>
Subject: Re: carl9170: Problems setting up Virtual Interface
Date: Mon, 4 Jul 2011 23:06:47 +0200
Cc: linux-wireless@vger.kernel.org
References: <CAMJnVwmtNBrAbaL5TU-pQO+cvFn=UJC2rQroJeYASL3zJEesaw@mail.gmail.com> <201107042242.25197.chunkeey@googlemail.com> <CAMJnVwmsOeSSKVpzkihtxHziKsGv1nH5qhRitSRJHkTenvNiJg@mail.gmail.com>
In-Reply-To: <CAMJnVwmsOeSSKVpzkihtxHziKsGv1nH5qhRitSRJHkTenvNiJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201107042306.47963.chunkeey@googlemail.com> (sfid-20110704_230706_712571_F07AF4D9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, July 04, 2011 10:54:44 PM Alex wrote:
> OK, I will set hostapd to use the same channel as my router
> (my router is on channel 3). So I will use "channel=3" in hostapd.conf
weird setup, but nevermind...

> What do I need to do to connect to the router with the virtual interface?
any iw dev wlanX connect ESSID should do it.
