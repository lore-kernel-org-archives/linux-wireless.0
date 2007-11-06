Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from astoria.ccjclearline.com ([64.235.106.9]:55988 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756563AbXKFJ5B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2007 04:57:01 -0500
Date: Tue, 6 Nov 2007 04:55:22 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
To: Johannes Berg <johannes@sipsolutions.net>
cc: linux-wireless@vger.kernel.org
Subject: Re: is net/mac80211/ieee80211_common.h being used?
In-Reply-To: <1194342976.4066.0.camel@johannes.berg>
Message-ID: <Pine.LNX.4.64.0711060455050.10166@localhost.localdomain> (sfid-20071106_095739_521515_FE91EC1B)
References: <Pine.LNX.4.64.0711060136410.30254@localhost.localdomain>
 (sfid-20071106_064027_299099_72B25D2B) <1194342976.4066.0.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 6 Nov 2007, Johannes Berg wrote:

>
> On Tue, 2007-11-06 at 01:38 -0500, Robert P. J. Day wrote:
> > hoping this is the right list, does that header file have any value
> > given that no one is including it?
>
> No, I should've removed it along with the management interface. I
> can send a patch.

ok, it's all yours.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
