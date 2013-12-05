Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f181.google.com ([209.85.223.181]:57326 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756873Ab3LEQc3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 11:32:29 -0500
Received: by mail-ie0-f181.google.com with SMTP id e14so30356680iej.12
        for <linux-wireless@vger.kernel.org>; Thu, 05 Dec 2013 08:32:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1386260099.4182.16.camel@jlt4.sipsolutions.net>
References: <1386235289-27278-1-git-send-email-eliad@wizery.com>
	<1386235289-27278-4-git-send-email-eliad@wizery.com>
	<1386253879.4182.4.camel@jlt4.sipsolutions.net>
	<CAB3XZEcpM9PAQCGQ99X2A-bqYXoPEmE=Cg29CDKY7=s8QquwUA@mail.gmail.com>
	<1386254607.4182.5.camel@jlt4.sipsolutions.net>
	<CAB3XZEc4pikahyAmPCh_pCjFEiRvFgAyZgxGrbH9A6hLP2nhFw@mail.gmail.com>
	<1386260099.4182.16.camel@jlt4.sipsolutions.net>
Date: Thu, 5 Dec 2013 18:32:28 +0200
Message-ID: <CAB3XZEdWhMDv5bRRS0M86wCwOJxC8fzd4fXY8b5rd6gh4CrK6w@mail.gmail.com> (sfid-20131205_173232_461928_549C9470)
Subject: Re: [PATCH 4/4] cfg80211: prevent race condition on scan request cleanup
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 5, 2013 at 6:14 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2013-12-05 at 17:39 +0200, Eliad Peller wrote:
>
>> > Btw, should any of this go to 3.13?
>> maybe the first one. it's the only "real" issue.
>
> Actually, I'm not going to take that into 3.13 - we defined the API so
> that the driver is always allowed to drop the scheduled scan, this isn't
> really any different, is it?
>
it doesn't getting stopped in normal cases (by the driver), and
wpa_supplicant doesn't seem to handle it well.
anyway, i guess we can wait with this patch as well.

Eliad.
