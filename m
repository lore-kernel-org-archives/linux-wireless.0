Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755288Ab0IIPzM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Sep 2010 11:55:12 -0400
Date: Thu, 9 Sep 2010 17:55:23 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/16 v2] iwlwifi: rewrite iwl-scan.c to avoid race
 conditions
Message-ID: <20100909155522.GA376@redhat.com>
References: <1284040354-31703-1-git-send-email-sgruszka@redhat.com>
 <E9954878DD1FB34FAE5187FB88C58A3501280FDC3D@orsmsx506.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <E9954878DD1FB34FAE5187FB88C58A3501280FDC3D@orsmsx506.amr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi.

On Thu, Sep 09, 2010 at 08:32:56AM -0700, Guy, Wey-Yi W wrote:
> Do we have any bugzilla bug# can associated to this set of patches?

Yes, I'm doing this for RHEL6 bug:
https://bugzilla.redhat.com/show_bug.cgi?id=593566

I'm pretty sure there are lot's of other "WARNING: at
net/wireless/core.c:614 wdev_cleanup_work" bug reports, which will
be most likely fixed by this patchset.
 
Stanislaw
