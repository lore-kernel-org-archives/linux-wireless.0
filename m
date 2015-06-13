Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:36139 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbbFMG0k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Jun 2015 02:26:40 -0400
Received: by wgzl5 with SMTP id l5so10866119wgz.3
        for <linux-wireless@vger.kernel.org>; Fri, 12 Jun 2015 23:26:38 -0700 (PDT)
Message-ID: <557BCD1C.5010408@gmail.com> (sfid-20150613_082657_386296_86548732)
Date: Sat, 13 Jun 2015 08:26:36 +0200
From: Arend van Spriel <aspriel@gmail.com>
MIME-Version: 1.0
To: Luca Coelho <luca@coelho.fi>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH py80211 0/4] py80211: add support for scheduled scan
References: <1434117644-3033-1-git-send-email-luca@coelho.fi>
In-Reply-To: <1434117644-3033-1-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12-06-15 16:00, Luca Coelho wrote:
> From: Luciano Coelho <luciano.coelho@intel.com>
> 
> Hi Arend,
> 
> Here's a small patchset that adds support for scheduled scans in
> py80211.

Thanks! One general remark. It seems you are using soft-tabs where I
stick to true tabs. Python is pretty anal about that so better stick to
true tabs.

> I'm not sure this is the right approach, I added separate classes for
> each command, so feel free to ask me to change it completely if you
> want and I may or may not do it. :P

Me neither, but it may be a bit too classy ;-) So I would prefer to have
a scheduled scan class with start and stop operation.

Good to see you are using '_' consistently for class private members and
functions. I need to clean it up in other files. I recently added Pyro
support allowing remote access to py80211 objects and it only exposes
public members and functions.

Thanks again,
Arend

> Cheers,
> Luca.
> 
> Luciano Coelho (4):
>   py80211: scan: spin base scan classes off scan_request
>   py80211: scan: add sched_scan start class
>   py80211: add sched_scan stop class
>   py80211: scan: add matchsets support for scheduled scans
> 
>  lib/scan.py | 157 +++++++++++++++++++++++++++++++++++++++++++++---------------
>  1 file changed, 119 insertions(+), 38 deletions(-)
> 
