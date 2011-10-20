Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55612 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932108Ab1JTLXC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Oct 2011 07:23:02 -0400
Subject: Re: Available nl80211 multicast groups
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?Andr=E9?= Prata <andreprata@ua.pt>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CAGEq-jBnU4gmb+A7ox3O0vwSr0HFkccEqBydH5cqNChZ_hTkDQ@mail.gmail.com> (sfid-20111019_213118_071850_6AC04F5E)
References: <CAGEq-jBnU4gmb+A7ox3O0vwSr0HFkccEqBydH5cqNChZ_hTkDQ@mail.gmail.com>
	 (sfid-20111019_213118_071850_6AC04F5E)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Oct 2011 13:22:57 +0200
Message-ID: <1319109777.3959.11.camel@jlt3.sipsolutions.net> (sfid-20111020_132306_720481_56448CC3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-10-19 at 20:30 +0100, André Prata wrote:
> Hi!
> 
> I saw on your code that you resolve the multicas id of several groups
> for the nl80211 family /online/, like "scan" and "mlme". I'd like to
> know if there are defined constants for those IDs (i'm guessing
> they're not).

There's no list it seems -- you'll have to look at nl80211.c.

> Also I wanted to know what other groups exist and what messages I
> should expect from them (no docs, or my bad search skills?).
> Is there a multicast group to get reports on link quality changes, or
> similar, or is that only available through polling?

You can subscribe to such changes though I think only one application
can do that right now and wpa_s will do it.

johannes

