Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753879Ab0CQJVT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Mar 2010 05:21:19 -0400
Date: Wed, 17 Mar 2010 10:19:06 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: Re: [RFC PATCH 1/2] mac80211: disable_qos callback
Message-ID: <20100317091906.GA3726@dhcp-lab-161.englab.brq.redhat.com>
References: <20100309132113.GA2462@dhcp-lab-161.englab.brq.redhat.com> <20100310152134.GC2969@dhcp-lab-161.englab.brq.redhat.com> <43e72e891003101231nc3cb3d3u3b1815a72e8e80fc@mail.gmail.com> <20100311093350.GA4682@dhcp-lab-161.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100311093350.GA4682@dhcp-lab-161.englab.brq.redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 11, 2010 at 10:33:50AM +0100, Stanislaw Gruszka wrote:
> On Wed, Mar 10, 2010 at 12:31:58PM -0800, Luis R. Rodriguez wrote:
> > What's the justification of a new callback for this? Can we not do
> > this through the general conf?
> 
> Missed that, I'll fix.

No, currently I do not want to change that, not in patch that is
intended to backport to -stable. Some drivers do some work no matter
what change flags are in ieee80211_ops->config , so that change would
be much more intrusive then I want it to be.

Stanislaw
