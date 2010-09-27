Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45439 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117Ab0I0Ugb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 16:36:31 -0400
Received: by fxm3 with SMTP id 3so2192938fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 13:36:30 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Joshua Smith <jesmith@kaon.com>
Subject: Re: Question about starting up an AP
Date: Mon, 27 Sep 2010 22:35:42 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <DA0C92FD-F6BF-4746-9BE1-A643A0D70F7A@kaon.com> <201009272143.52283.helmut.schaa@googlemail.com> <EA2A527E-E8DA-4612-B8CB-518E2C6BA7D2@kaon.com>
In-Reply-To: <EA2A527E-E8DA-4612-B8CB-518E2C6BA7D2@kaon.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201009272235.42545.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Montag 27 September 2010 schrieb Joshua Smith:
> 
> On Sep 27, 2010, at 3:43 PM, Helmut Schaa wrote:
> 
> > Am Montag 27 September 2010 schrieb Joshua Smith: 
> >> I have another problem with these cards and hostapd where occasionally they
> >> will send a beacon but not respond to clients trying to join the network. 
> >> However, stopping hostapd and restarting it clears this condition.
> > 
> > Most likely a stuck tx queue. Do you have 11n enabled?
> 
> No.  My hostapd has:
> 
> hw_mode=a
> 
> Is that consistent or inconsistent with your stuck tx queue theory?

With 11n it is more likely to occur. So, it might be the same issue.

> > A fix to make the tx queue not stuck anymore (at least on rt3052 SoC) is
> > already in rt2x00 git [1] and [2]. However, I'm not sure if this is the same
> > issue you're facing.
> 
> Would things "already in rt2x00 git" be in the compat-wireless bleeding edge tarball?

Nope. But it means they are on their way into wireless-testing and thus into
compat-wireless.

Helmut
