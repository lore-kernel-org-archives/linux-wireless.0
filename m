Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:37854 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982AbXH3PpP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2007 11:45:15 -0400
Date: Thu, 30 Aug 2007 09:45:13 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
	Jochen Voss <voss@seehuhn.de>,
	linux wireless list <linux-wireless@vger.kernel.org>,
	linville@tuxdriver.com, netdev <netdev@vger.kernel.org>,
	bridge@linux-foundation.org
Subject: Re: oops with recent wireless-dev tree
Message-ID: <20070830154513.GV14130@parisc-linux.org>
References: <20070829223752.GA6969@seehuhn.de> <1188475530.2963.20.camel@johannes.berg> <20070830074949.7cd25b04@freepuppy.rosehill.hemminger.net> <1188486091.3978.32.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1188486091.3978.32.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 30, 2007 at 05:01:31PM +0200, Johannes Berg wrote:
> Jochen had a patch: http://marc.info/?l=linux-wireless&m=118842715026614&w=2

That's exactly the right patch, please add

Acked-by: Matthew Wilcox <matthew@wil.cx>

I just checked over the commit that introduced the bug, and I didn't
make the same mistake anywhere else.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
