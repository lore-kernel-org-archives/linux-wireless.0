Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55832 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab1FYNI4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jun 2011 09:08:56 -0400
Subject: Re: [3.0 regression] DMAR faults in iwlagn
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Lutomirski <luto@mit.edu>,
	Kyle McMartin <kmcmartin@redhat.com>
Cc: ilw@linux.intel.com, linux-wireless@vger.kernel.org
In-Reply-To: <BANLkTi=-=EbuijX-RLeyD-GKv+fFYf+B2g@mail.gmail.com> (sfid-20110624_171411_462603_69EC6B86)
References: <BANLkTikKia-UXL8LJ60sLDV1uZBFEP8Kwg@mail.gmail.com>
	 <1308774283.29571.24.camel@jlt3.sipsolutions.net>
	 <BANLkTi=-=EbuijX-RLeyD-GKv+fFYf+B2g@mail.gmail.com>
	 (sfid-20110624_171411_462603_69EC6B86)
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 25 Jun 2011 15:08:51 +0200
Message-ID: <1309007331.4317.1.camel@jlt3.sipsolutions.net> (sfid-20110625_150858_988329_FE02490B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-06-24 at 09:13 -0600, Andrew Lutomirski wrote:
> On Wed, Jun 22, 2011 at 2:24 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > Andy, could you try this patch?
> >
> > I haven't tested it at all yet, it's kinda late here.

> Works for me.
> 
> Tested-by: Andy Lutomirski <luto@mit.edu>

Thanks Andrew, Kyle.

I don't pretend to understand what the device is doing, but for now I
guess we'll keep this and I'll try to figure out independently why this
happens.

johannes

