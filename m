Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:41478 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbXB1PnS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 10:43:18 -0500
Received: by nf-out-0910.google.com with SMTP id o25so590803nfa
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 07:43:17 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 14/28] rt2x00: Create rt2x00lib module
Date: Wed, 28 Feb 2007 16:43:13 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200702281507.13004.IvDoorn@gmail.com> <200702281634.47330.IvDoorn@gmail.com> <1172677140.5015.22.camel@johannes.berg>
In-Reply-To: <1172677140.5015.22.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702281643.13490.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 28 February 2007 16:39, Johannes Berg wrote:
> On Wed, 2007-02-28 at 16:34 +0100, Ivo van Doorn wrote:
> 
> > Nope, in my test it will show up in the menu. The help text has no influence.
> > When the help text is not specified, selecting help on that entry will display
> > "There is no help available for this kernel option." followed by the regular
> > dependency information for that option.
> 
> I think that's only true if other things depend on it as opposed to
> selecting it. I know that cfg80211 used to not show up in Kconfig (and
> that was intentional)

Nothing depended on RT2X00_LIB, I only had the drivers select RT2X00_LIB.
So something has changed or I am missing something. ;)

Ivo
