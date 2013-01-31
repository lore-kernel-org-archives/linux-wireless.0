Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55353 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab3AaPkK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 10:40:10 -0500
Message-ID: <1359646831.8415.82.camel@jlt4.sipsolutions.net> (sfid-20130131_164017_824529_1165CD29)
Subject: Re: [PATCH] iw:  Print beacon-loss-event string.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Thu, 31 Jan 2013 16:40:31 +0100
In-Reply-To: <1359610289-4578-1-git-send-email-greearb@candelatech.com> (sfid-20130131_063151_387238_C974953B)
References: <1359610289-4578-1-git-send-email-greearb@candelatech.com>
	 (sfid-20130131_063151_387238_C974953B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-01-30 at 21:31 -0800, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> There are now three possible threshold events.  The old
> code assumed only above/below RSSI, and printed out 'low'
> for beacon-loss-event.
> 
> Fix that, and do so with a switch statement so the compiler
> can warn if the enum is further expanded w/out updating this
> code.
> 
> Shorten 'connection quality monitor' to CQM to keep total string
> relatively short.

Applied.

johannes

