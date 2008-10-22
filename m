Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:6451 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755953AbYJVUei (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 16:34:38 -0400
Subject: Re: [PATCH 6/9] iwlwifi: refactor TX response flow
From: reinette chatre <reinette.chatre@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Winkler, Tomas" <tomas.winkler@intel.com>
In-Reply-To: <20081022195149.GH15808@tuxdriver.com>
References: <1224012769-8920-1-git-send-email-reinette.chatre@intel.com>
	 <1224012769-8920-2-git-send-email-reinette.chatre@intel.com>
	 <1224012769-8920-3-git-send-email-reinette.chatre@intel.com>
	 <1224012769-8920-4-git-send-email-reinette.chatre@intel.com>
	 <1224012769-8920-5-git-send-email-reinette.chatre@intel.com>
	 <1224012769-8920-6-git-send-email-reinette.chatre@intel.com>
	 <1224012769-8920-7-git-send-email-reinette.chatre@intel.com>
	 <20081022195149.GH15808@tuxdriver.com>
Content-Type: text/plain
Date: Wed, 22 Oct 2008 13:34:55 -0700
Message-Id: <1224707695.10863.162.camel@rc-desk> (sfid-20081022_223442_410038_3CA84ED1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-10-22 at 12:51 -0700, John W. Linville wrote:
> On Tue, Oct 14, 2008 at 12:32:46PM -0700, Reinette Chatre wrote:
> > From: Tomas Winkler <tomas.winkler@intel.com>
> >
> > This patch utilize 5000 new TX response command
> > which contains all necessary information and avoids
> > back referencing to the original TX frame.
> > It also change handling of software queue tracking
> > 4965 flow is aligned with changes as much as possible.
> >
> > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> > Reviewed-by: Zhu Yi <yi.zhu@intel.com>
> > Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> 
> What is this based upon?  It doesn't seem to apply to wireless-testing.

It is supposed to be based on wireless-testing. It sounds as though you
are updating wireless-testing at the moment. I can resend this patch
when you are done.

Reinette

