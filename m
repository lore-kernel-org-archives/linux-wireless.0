Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38293 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbaAON3b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 08:29:31 -0500
Message-ID: <1389792568.4338.12.camel@jlt4.sipsolutions.net> (sfid-20140115_142934_702467_7F0A1999)
Subject: Re: [RFC 6/9] mac80211: track CSA globally
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 15 Jan 2014 14:29:28 +0100
In-Reply-To: <CA+BoTQ=ppr=npj_f58Ckv4LGpMb+PSTRkzFtLh5jt1PYQCXLhg@mail.gmail.com> (sfid-20140115_142815_559659_6352D8AC)
References: <1389787494-7361-1-git-send-email-michal.kazior@tieto.com>
	 <1389787494-7361-7-git-send-email-michal.kazior@tieto.com>
	 <1389791963.4338.4.camel@jlt4.sipsolutions.net>
	 <CA+BoTQ=ppr=npj_f58Ckv4LGpMb+PSTRkzFtLh5jt1PYQCXLhg@mail.gmail.com>
	 (sfid-20140115_142815_559659_6352D8AC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-15 at 14:28 +0100, Michal Kazior wrote:
> On 15 January 2014 14:19, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Wed, 2014-01-15 at 13:04 +0100, Michal Kazior wrote:
> >> For CSA to be safe it needs to be treated the same
> >> way as radar detection, scanning and remain on
> >> channel - all of those (including CSA) must be
> >> mutually exclusive.
> >
> > This I don't understand. Why couldn't you do a remain-on(some
> > other)-channel or scan while counting down the beacons?
> 
> My concern is software offchannel (be it scan or roc) involves channel
> context switches. I wanted to avoid any channel context mangling while
> CSA is in progress. Does that make sense to you?

No, I don't really get it. Why?

johannes

