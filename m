Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42866 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964841Ab2HWRTL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2012 13:19:11 -0400
Received: by ialo24 with SMTP id o24so1663385ial.19
        for <linux-wireless@vger.kernel.org>; Thu, 23 Aug 2012 10:19:10 -0700 (PDT)
Message-ID: <5036660B.9020208@lwfinger.net> (sfid-20120823_191947_529040_A0C3E052)
Date: Thu, 23 Aug 2012 12:19:07 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Patrick Connolly <pjc999@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Question about ath9k/mac80211 Driver
References: <CAE3CJbkhmZ75gBjEToshQ2M9Xu7ciVrDtv8n2DVZepnhBoNt-Q@mail.gmail.com> <50365AC8.7030503@lwfinger.net> <CAE3CJbm5a0hZ8uWT8yU5Z8vbKX2HNwZ2uPUFULGA-3no1XFc_Q@mail.gmail.com>
In-Reply-To: <CAE3CJbm5a0hZ8uWT8yU5Z8vbKX2HNwZ2uPUFULGA-3no1XFc_Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/23/2012 12:07 PM, Patrick Connolly wrote:
> Larry,
>       Thanks for the response.  It appears that "set bitrates" is not
> possible with my version of iw (0.9.19) - I get a big long help screen
> when I try that command:
>
>   "iw dev wlan0 set bitrates legacy-2.4 1 2 5.5 11"
> ...the options printed out for "set" are:

You need to upgrade iw. I have 0.9.22, which has the set bitrates option.

Once the rates are locked by mac80211, the beacons should only advertise 802.11b 
rates. (I have not tested that statement.)

Larry

