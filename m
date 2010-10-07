Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns6.cs.washington.edu ([128.208.6.1]:41985 "EHLO
	ns6.cs.washington.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882Ab0JGTGe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 15:06:34 -0400
Date: Thu, 7 Oct 2010 11:31:49 -0700 (PDT)
From: Daniel Halperin <dhalperi@cs.washington.edu>
To: Johannes Berg <johannes@sipsolutions.net>
cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
Subject: Re: [ipw3945-devel] [PATCH 1/6] iwlwifi: schedule to deprecate
 software scan support
In-Reply-To: <1286440790.3657.28.camel@jlt3.sipsolutions.net>
Message-ID: <alpine.LFD.2.00.1010071131160.9851@kishwoot.cs.washington.edu>
References: <1286378593-7509-1-git-send-email-wey-yi.w.guy@intel.com> <1286378593-7509-2-git-send-email-wey-yi.w.guy@intel.com> <20101006173609.GH2472@tuxdriver.com> <1286387500.12594.24.camel@wwguy-ubuntu> <20101006190343.GI2472@tuxdriver.com>
 <1286440790.3657.28.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 7 Oct 2010, Johannes Berg wrote:

> On Wed, 2010-10-06 at 15:03 -0400, John W. Linville wrote:
>
>>> The current HW scan implementation was improve a lot and sw scan will
>>> cause problem, especially once we introduce P2P.
>>
>> What support issues are caused by supporting software scanning?
>>
>> Whatever issues are caused by scanning with P2P, doesn't mac80211
>> have to handle them anyway?
>
> Technically, yes, but there are some things it doesn't handle today, and
> there are some things in mac80211's scan implementation that
> unfortunately make our firmware somewhat unhappy. Also, when we have two
> virtual interfaces (for p2p) the firmware can get completely confused by
> a software scan, especially when we were operating as a p2p-GO.
>

Is there a description somewhere of the p2p functionality, modes, etc?

Thanks,
Dan
