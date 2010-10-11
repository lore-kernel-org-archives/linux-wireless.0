Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60052 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697Ab0JKSoB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 14:44:01 -0400
Subject: Re: [PATCH 1/2] wireless:  Support wiphy_renamed hook for drivers.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1286822537-28756-1-git-send-email-greearb@candelatech.com>
References: <1286822537-28756-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Oct 2010 20:43:59 +0200
Message-ID: <1286822639.3634.84.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-10-11 at 11:42 -0700, greearb@candelatech.com wrote:

> Some drivers may want to know when their wiphy is updated
> so that they can reuname debugfs links, etc.

I really don't like this -- we provide a debugfs directory that follows
the correct name that drivers can use, so for that particular purpose
this isn't worthwhile. And there seems no other purpose really.

johannes

