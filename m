Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.228]:12862 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbYKLSTJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2008 13:19:09 -0500
Received: by rv-out-0506.google.com with SMTP id k40so526063rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 12 Nov 2008 10:19:08 -0800 (PST)
Subject: Re: [RFC PATCH 1/4] lib80211: absorb crypto bits from net/ieee80211
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20081112180228.GC2411@tuxdriver.com>
References: <1226440265-21240-1-git-send-email-linville@tuxdriver.com>
	 <1226508514.5368.21.camel@brick>  <20081112180228.GC2411@tuxdriver.com>
Content-Type: text/plain
Date: Wed, 12 Nov 2008 10:19:03 -0800
Message-Id: <1226513943.16649.0.camel@brick> (sfid-20081112_191917_368629_FF28580A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-11-12 at 13:02 -0500, John W. Linville wrote:
> On Wed, Nov 12, 2008 at 08:48:34AM -0800, Harvey Harrison wrote:
> > On Tue, 2008-11-11 at 16:51 -0500, John W. Linville wrote:
> > > These bits are shared already between ipw2x00 and hostap, and could
> > > probably be shared both more cleanly and with other drivers.  This
> > > commit simply relocates the code to lib80211 and adjusts the drivers
> > > appropriately.
> > > 
> > > Signed-off-by: John W. Linville <linville@tuxdriver.com>
> > > ---
> > 
> > Wouldn't it have been better to start from the mac80211 crypto bits
> > as lib80211 and modify hostap/ipw2x00 to use the 'new' lib80211
> > crypto bits?
> 
> I'm sorry, but you forgot to attach your patches...
> 

I will if it's desired, I just wanted to know if there was a particular
reason for going this way.

Cheers,

Harvey

