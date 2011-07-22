Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:50666 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752833Ab1GVONE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 10:13:04 -0400
Subject: Re: 3.0: iwlagn: BUG: unable to handle kernel NULL pointer
 dereference at 0000000000000004
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <CACVXFVNe=4MEyv=9di7Yh+E-mifdMT77PxmBxFBM0PWvHwVY9g@mail.gmail.com>
References: <CACVXFVNe=4MEyv=9di7Yh+E-mifdMT77PxmBxFBM0PWvHwVY9g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Jul 2011 06:36:48 -0700
Message-ID: <1311341808.5579.51.camel@wwguy-huron> (sfid-20110722_161308_930462_23EC5237)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Lei,

On Fri, 2011-07-22 at 03:54 -0700, Ming Lei wrote:
> Hi,
> 
> The bug is triggered after I run 'pm-suspend' to do system sleep.
> 
> See attachment.

Could you try this patch in mac80211 from wireless-next-2.6 tree


commit 94f9b97be5b3bf67392e43fb7f567721b09142c2
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Thu Jul 14 16:48:54 2011 +0200

    mac80211: be more careful in suspend/resume
    


Thanks
Wey

