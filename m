Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53809 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab1KDTc3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 15:32:29 -0400
Subject: Re: crash in wireless-next
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4EB42C0C.40101@candelatech.com> (sfid-20111104_191656_642276_99C645ED)
References: <4EB42C0C.40101@candelatech.com>
	 (sfid-20111104_191656_642276_99C645ED)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Nov 2011 20:32:26 +0100
Message-ID: <1320435146.3969.125.camel@jlt3.sipsolutions.net> (sfid-20111104_203233_422852_33ADA66F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-11-04 at 11:16 -0700, Ben Greear wrote:
> Anyone seen a crash like this?  I was restarting my user-space
> tools, and had just unloaded the drivers that had,
> around 135 virtual stations created.  Just my disable-ht
> patch series applied on top of yesterday's wireless-testing.
> 
> I'll dig into it more when I get a chance, but let me know
> if someone is already working on this...

The only crash in wext I ever saw was recently with compat but I don't
think that looked similar.

johannes

