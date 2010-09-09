Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31170 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636Ab0IIQGa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Sep 2010 12:06:30 -0400
Date: Thu, 9 Sep 2010 18:06:47 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/16 v2] iwlwifi: rewrite iwl-scan.c to avoid race
 conditions
Message-ID: <20100909160646.GB376@redhat.com>
References: <1284040354-31703-1-git-send-email-sgruszka@redhat.com>
 <E9954878DD1FB34FAE5187FB88C58A3501280FDC3D@orsmsx506.amr.corp.intel.com>
 <20100909155522.GA376@redhat.com>
 <E9954878DD1FB34FAE5187FB88C58A3501280FDCC3@orsmsx506.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <E9954878DD1FB34FAE5187FB88C58A3501280FDCC3@orsmsx506.amr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 09, 2010 at 08:57:10AM -0700, Guy, Wey-Yi W wrote:
> > Do we have any bugzilla bug# can associated to this set of patches?
> 
> Yes, I'm doing this for RHEL6 bug:
> https://bugzilla.redhat.com/show_bug.cgi?id=593566
> 
> I'm pretty sure there are lot's of other "WARNING: at
> net/wireless/core.c:614 wdev_cleanup_work" bug reports, which will
> be most likely fixed by this patchset.
> 
> 
> Could these bug# be part of description which can help us keep track of the bugs status

Sure. But you mean patch 0 description ? That text does not go to
changelog, but at least is keep on mailing list archives ...

Stanislaw
