Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41492 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab2BXRbk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 12:31:40 -0500
Received: by iazz13 with SMTP id z13so332211iaz.19
        for <linux-wireless@vger.kernel.org>; Fri, 24 Feb 2012 09:31:40 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 24 Feb 2012 09:31:40 -0800
Message-ID: <CA+yqC4buizhVjtWMTSfaD2c8d+cLjn13a-H2Ez883gxy8K8j+g@mail.gmail.com> (sfid-20120224_183144_387473_09E922B0)
Subject: Re: [RFC] mac80211: Filter duplicate IE ids [corrupted beacons]
From: Sam Leffler <sleffler@google.com>
To: Paul Stewart <pstew@chromium.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 24, 2012 at 7:43 AM, Paul Stewart <pstew@chromium.org> wrote:

> If my over-the-air captures are any indication, with some probability
> you will receive a corrupted beacon from time to time -- perhaps not
> due to a broken AP, but just from it being corrupted over the air.
> FCS could catch that most times, but perhaps sometimes not.

I can't recall ever receiving a "corrupted frame" that passed FCS and
wasn't delivered due to some driver/hw problem.

-Sam
