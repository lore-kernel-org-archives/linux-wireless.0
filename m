Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37760 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138Ab0I3Pis (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 11:38:48 -0400
Subject: Re: [RFC 1/2] wireless:  Show sta_flags for status in
 /proc/net/wireless
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4CA4AD40.1010309@candelatech.com>
References: <1285804637-5400-1-git-send-email-greearb@candelatech.com>
	 <1285832587.3639.1.camel@jlt3.sipsolutions.net>
	 <4CA4AD40.1010309@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Sep 2010 17:39:21 +0200
Message-ID: <1285861161.5137.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-09-30 at 08:31 -0700, Ben Greear wrote:

> It would of course be easy to map them to a stable set of flags, but if you
> don't want to fix /proc/net/wireless anyway, then I might as well do minimal changes
> to make it easier to keep the patch in my own tree.
> 
> Aside from listening to 'iw event', is there any way to know if a STA is scanning,
> authenticated, associated, etc?  Some of this can be obtained from debugfs, but
> that's not a fun api to code against...

You can't get scanning, but auth/assoc should be visible in "iw dev
<iface> scan dump"

johannes

