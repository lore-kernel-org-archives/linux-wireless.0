Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:56618 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101Ab0IIP5V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Sep 2010 11:57:21 -0400
From: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 9 Sep 2010 08:57:10 -0700
Subject: RE: [PATCH 0/16 v2] iwlwifi: rewrite iwl-scan.c to avoid race
 conditions
Message-ID: <E9954878DD1FB34FAE5187FB88C58A3501280FDCC3@orsmsx506.amr.corp.intel.com>
References: <1284040354-31703-1-git-send-email-sgruszka@redhat.com>
 <E9954878DD1FB34FAE5187FB88C58A3501280FDC3D@orsmsx506.amr.corp.intel.com>
 <20100909155522.GA376@redhat.com>
In-Reply-To: <20100909155522.GA376@redhat.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Gruszka,

-----Original Message-----
From: Stanislaw Gruszka [mailto:sgruszka@redhat.com]
Sent: Thursday, September 09, 2010 8:55 AM
To: Guy, Wey-Yi W
Cc: Johannes Berg; Chatre, Reinette; John W. Linville; linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/16 v2] iwlwifi: rewrite iwl-scan.c to avoid race conditions

Hi.

On Thu, Sep 09, 2010 at 08:32:56AM -0700, Guy, Wey-Yi W wrote:
> Do we have any bugzilla bug# can associated to this set of patches?

Yes, I'm doing this for RHEL6 bug:
https://bugzilla.redhat.com/show_bug.cgi?id=593566

I'm pretty sure there are lot's of other "WARNING: at
net/wireless/core.c:614 wdev_cleanup_work" bug reports, which will
be most likely fixed by this patchset.


Could these bug# be part of description which can help us keep track of the bugs status

Thanks
Wey
