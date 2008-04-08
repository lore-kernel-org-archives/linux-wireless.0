Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2083 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753686AbYDHSbT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2008 14:31:19 -0400
Date: Tue, 8 Apr 2008 14:04:41 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
Cc: Jason Riedy <jason@acm.org>, ipw3945-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Make IWLCORE a silent option not to confuse iwl3945
	users.
Message-ID: <20080408180441.GB8183@tuxdriver.com> (sfid-20080408_193125_266739_CDF839C1)
References: <874pakhist.fsf@sparse.dyndns.org> <D936D925018D154694D8A362EEB0892004195168@orsmsx416.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <D936D925018D154694D8A362EEB0892004195168@orsmsx416.amr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 03, 2008 at 09:14:23AM -0700, Chatre, Reinette wrote:
> On Tuesday, April 01, 2008 11:29 PM,
> linux-wireless-owner@vger.kernel.org  wrote:
> 
> > The iwl3945 (currently?) does not use iwlcore.  Either the iwlcore
> > documentation should change or the option should be silent.  This
> > patch follows the latter route.  IWL4965 already SELECTs IWLCORE,
> > so there should be no new problems.  Note that IWLWIFI_DEBUGFS and
> > IWLCORE_RFKILL have no suboptions for 4965, so they are grouped
> > together and given a description that includes "4965+" to indicate
> > they're not for the 3945 adapters.
> > 
> > Signed-off-by: Jason Riedy <jason@acm.org>
> 
> We are moving to a common library for the devices and changing
> CONFIG_IWLWIFI_DEBUG to CONFIG_IWL4965_DEBUG undoes this work. Please be
> patient as we move to common code.
> 
> The numerous Kconfig variables help us to add and test the new features
> during development. They should not be there permanently.

I think it makes sense to make IWLCORE invisible, but this patch
seems not quite right.  I'm dropping it -- feel free to repost a
revised version.

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
