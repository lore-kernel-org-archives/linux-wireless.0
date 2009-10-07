Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:38747 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933327AbZJGAWa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2009 20:22:30 -0400
Received: by iwn8 with SMTP id 8so2575689iwn.33
        for <linux-wireless@vger.kernel.org>; Tue, 06 Oct 2009 17:21:53 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 6 Oct 2009 20:21:33 -0400
Message-ID: <43e72e890910061721o5f78f82cvfaa216a4d887e4f8@mail.gmail.com>
Subject: Re: [ath5k-devel] Regarding changing channel widthlin
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: Aditya <aybhave@cmu.edu>, ath5k-devel@lists.ath5k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 6, 2009 at 5:17 PM, Nick Kossifidis <mickflemm@gmail.com> wrote:
> Until we have a
> clean way to set this through cfg80211/nl80211 (which is an ongoing
> discussion) we wont support 5/10Mhz operation but you can try and let
> us know.

I believe the cfg80211/nl80211 changes is probably the bulk of the
work that does need to get done. Someone motivated just needs to do
it.

   Luis
