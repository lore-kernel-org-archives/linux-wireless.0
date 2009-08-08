Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:27346 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932977AbZHHDea (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 23:34:30 -0400
Subject: Re: [PATCH 0/3] roaming/disassoc fixes
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090806184131.114246687@sipsolutions.net>
References: <20090806184131.114246687@sipsolutions.net>
Content-Type: text/plain
Date: Fri, 07 Aug 2009 23:34:28 -0400
Message-Id: <1249702468.25983.33.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-08-06 at 20:41 +0200, Johannes Berg wrote:
> Pavel reported a bug, and it was hard to fix :)
> 
> Here's the fix patchset, including another fix
> for a bug I noticed while testing.
> 
> This requires Pavel's patch, of course, but applies
> without it in the tree too.

I'm getting a reasonable behavior in the managed mode now.  Thank you!

-- 
Regards,
Pavel Roskin
