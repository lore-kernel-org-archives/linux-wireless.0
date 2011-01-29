Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37122 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133Ab1A2Asv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jan 2011 19:48:51 -0500
Received: by iwn9 with SMTP id 9so3643309iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 28 Jan 2011 16:48:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D4362BF.7050208@candelatech.com>
References: <4D4345A8.6060806@candelatech.com> <4D435D76.2040703@candelatech.com>
 <AANLkTimji+Y0KfDCzWDX63KfOjRFzxgKbVAq6HhMcw20@mail.gmail.com> <4D4362BF.7050208@candelatech.com>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Fri, 28 Jan 2011 16:48:30 -0800
Message-ID: <AANLkTimG05o=y2xGXh0YAmRqbuixifKp7xgmU7sH61Uf@mail.gmail.com>
Subject: Re: hti->control_chan is 15??
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 28, 2011 at 4:43 PM, Ben Greear <greearb@candelatech.com> wrote:
> My AP is an off-the-shelf Netgear:
> WNDR3700
>
> It's only rate configuration option is '300Mbps', which appears to
> turn on HT40.
>
> It is configured for channel 10 (for the packet capture) and actually
> passes traffic there.  It's just this HT Info thing with (primary-channel ==
> (real_channel + 4))
> that seems wrong.  Note that when I had the channel set to 11, it was
> reporting
> 15 for the primary channel in the HT info.
>
> Looks like a bug in that AP to me...but would be nice if there were a way to
> work around it, in case others have similar issues.

Set it to channel 6, then?

Yeah, I played with Netgear's APs (and D-Link's) for about 3 hours
before I put them down and never picked them up again.  Performance,
configuration, reliability, etc., were horrible.  I've found that
Apple APs work well, but really hostapd offers the best flexibility by
far.

Dan
