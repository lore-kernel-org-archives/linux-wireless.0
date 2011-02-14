Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45546
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752797Ab1BNV2S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 16:28:18 -0500
Date: Mon, 14 Feb 2011 13:28:54 -0800 (PST)
Message-Id: <20110214.132854.260094645.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: wey-yi.w.guy@intel.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Re: [PATCH 1/1] iwl3945: iwl3945_good_plcp_health might not used
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110214210516.GH2722@tuxdriver.com>
References: <20110214201052.GE2722@tuxdriver.com>
	<1297715460.4723.18.camel@wwguy-ubuntu>
	<20110214210516.GH2722@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 14 Feb 2011 16:05:17 -0500

> On Mon, Feb 14, 2011 at 12:31:00PM -0800, wwguy wrote:
>> On Mon, 2011-02-14 at 12:10 -0800, John W. Linville wrote:
>> > On Mon, Feb 14, 2011 at 07:57:33AM -0800, wwguy wrote:
>> > > On Mon, 2011-02-14 at 07:54 -0800, Johannes Berg wrote:
>> > > > On Mon, 2011-02-14 at 07:48 -0800, wwguy wrote:
>> > > > > On Mon, 2011-02-14 at 07:28 -0800, Johannes Berg wrote:
>> > > > > > On Mon, 2011-02-14 at 07:25 -0800, wwguy wrote:
>> > > > > > > On Mon, 2011-02-14 at 01:55 -0800, Johannes Berg wrote:
>> > > > > > > > On Thu, 2011-02-10 at 08:16 -0800, Wey-Yi Guy wrote:
>> > > > > > > > > remove plcp check for 3945, mark the function __maybe_unused
>> > > > > > > > 
>> > > > > > > > Why not remove the function instead?
>> > > > > > > > 
>> > > > > > > I guess we can remove it in legacy driver
>> > > > > > 
>> > > > > > But it's a 3945 specific function, and never used, so ...??
>> > > > > > 
>> > > > > I mean we should remove this function in legacy driver after driver
>> > > > > split
>> > > > 
>> > > > I just don't see why we can't remove it right now?
>> > > > 
>> > > we can do it for _stable, for mainstream, all 3945 will move to separate
>> > > driver anyway.
>> > 
>> > ...where it will still be unused.  No?
>> > 
>> we will remove it from our legacy driver
> 
> I don't really see any reason to wait, so let's just remove it now. :-)

It's now done in net-2.6
