Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46176 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab1AUUbp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 15:31:45 -0500
Received: by bwz15 with SMTP id 15so1957510bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 21 Jan 2011 12:31:43 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Fwd: [Linux Wireless] Update of "en/users/Drivers/carl9170" by PaulFertser
Date: Fri, 21 Jan 2011 21:31:35 +0100
Cc: Paul Fertser <fercerpav@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <20110120183210.13527.33808@he.sipsolutions.net> <20110120185440.GA25136@home.lan> <1295550433.3693.50.camel@jlt3.sipsolutions.net>
In-Reply-To: <1295550433.3693.50.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201101212131.36049.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 20 January 2011 20:07:13 Johannes Berg wrote:
> On Thu, 2011-01-20 at 21:54 +0300, Paul Fertser wrote:
> > On Thu, Jan 20, 2011 at 10:50:43AM -0800, Luis R. Rodriguez wrote:
> > > On Thu, Jan 20, 2011 at 10:43 AM, Paul Fertser <fercerpav@gmail.com> wrote:
> > > > On Thu, Jan 20, 2011 at 10:37:20AM -0800, Luis R. Rodriguez wrote:
> > > >> Huh?
> > > >
> > > > Christian asked me to add that info to the wiki, is something i wrote wrong?
> > > 
> > > It is unclear to me, are you saying carl9170 does not support QoS and
> > > aggregation?
> > 
> > At the same time, apparently, yes. This commit[1] has more
> > clarifications.
> > 
> > [1] http://git.kernel.org/?p=linux/kernel/git/chr/carl9170fw.git;a=commitdiff;h=39be7dc384e0dd45dc36b4b517fd9fae874b06f0
> 
> It could still do QoS but refuse aggregation sessions on anything but
> TID 0 and 1?
> 
Uh, no cc: me ;) ? I almost missed this one.

Anyway, when I wrote that I tried a lot of possible workarounds. 
Including this suggestion [limit ampdu to tid 0 & 1], but it had
no effect, the TX-QoS arbiter just gets stuck :(.



