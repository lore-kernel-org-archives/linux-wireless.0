Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:55919 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753022AbZKLGRY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2009 01:17:24 -0500
Subject: Re: [PATCH 2/2] ipw2200: Set core hw rfkill status when hardware
 changes state
From: Zhu Yi <yi.zhu@intel.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
In-Reply-To: <1257968191-495-2-git-send-email-mjg@redhat.com>
References: <1257968191-495-1-git-send-email-mjg@redhat.com>
	 <1257968191-495-2-git-send-email-mjg@redhat.com>
Content-Type: text/plain
Date: Thu, 12 Nov 2009 14:17:28 +0800
Message-Id: <1258006648.31116.51.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-11-12 at 03:36 +0800, Matthew Garrett wrote:
> ipw2200 is able to detect when it's been hard-killed, but doesn't
> update
> the core rfkill state or update userspace. Ensure that the state is
> updated,
> allowing the rfkill core to notify userspace.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>

Acked-by: Zhu Yi <yi.zhu@intel.com>

Thanks,
-yi

