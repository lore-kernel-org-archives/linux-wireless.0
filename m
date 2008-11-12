Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50376 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644AbYKLSQJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2008 13:16:09 -0500
Date: Wed, 12 Nov 2008 13:02:28 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH 1/4] lib80211: absorb crypto bits from net/ieee80211
Message-ID: <20081112180228.GC2411@tuxdriver.com> (sfid-20081112_191620_795769_00B55502)
References: <1226440265-21240-1-git-send-email-linville@tuxdriver.com> <1226508514.5368.21.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1226508514.5368.21.camel@brick>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 12, 2008 at 08:48:34AM -0800, Harvey Harrison wrote:
> On Tue, 2008-11-11 at 16:51 -0500, John W. Linville wrote:
> > These bits are shared already between ipw2x00 and hostap, and could
> > probably be shared both more cleanly and with other drivers.  This
> > commit simply relocates the code to lib80211 and adjusts the drivers
> > appropriately.
> > 
> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
> > ---
> 
> Wouldn't it have been better to start from the mac80211 crypto bits
> as lib80211 and modify hostap/ipw2x00 to use the 'new' lib80211
> crypto bits?

I'm sorry, but you forgot to attach your patches...

-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
