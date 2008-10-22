Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:39945 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753572AbYJVUhf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 16:37:35 -0400
Subject: Re: [PATCH 7/9] iwl3945 : Fix a-band association for passive
	channels
From: reinette chatre <reinette.chatre@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"Zhu, Yi" <yi.zhu@intel.com>
In-Reply-To: <20081022193353.GG15808@tuxdriver.com>
References: <1224012769-8920-1-git-send-email-reinette.chatre@intel.com>
	 <1224012769-8920-2-git-send-email-reinette.chatre@intel.com>
	 <1224012769-8920-3-git-send-email-reinette.chatre@intel.com>
	 <1224012769-8920-4-git-send-email-reinette.chatre@intel.com>
	 <1224012769-8920-5-git-send-email-reinette.chatre@intel.com>
	 <1224012769-8920-6-git-send-email-reinette.chatre@intel.com>
	 <1224012769-8920-7-git-send-email-reinette.chatre@intel.com>
	 <1224012769-8920-8-git-send-email-reinette.chatre@intel.com>
	 <20081022193353.GG15808@tuxdriver.com>
Content-Type: text/plain
Date: Wed, 22 Oct 2008 13:37:52 -0700
Message-Id: <1224707872.10863.165.camel@rc-desk> (sfid-20081022_223738_338604_CF30397D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-10-22 at 12:33 -0700, John W. Linville wrote:
> On Tue, Oct 14, 2008 at 12:32:47PM -0700, Reinette Chatre wrote:
> > From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
> >
> > This patch fixes the a-band association for passive channels.
> > This fix will only work with uCode version 15.28.1.8 and above.
> > uCode API version is incremented to 2.
> >
> > Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
> > Signed-off-by: Zhu Yi <yi.zhu@intel.com>
> 
> BTW, what is wrong with "the a-band association for passive channels"?
> As you may know, we have been trying to get better changelog
> information from the iwlwifi team for a while now...

This patch fixes associating with hidden AP in A-band.

Reinette

