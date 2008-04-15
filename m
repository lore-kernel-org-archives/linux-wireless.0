Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:62172 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754937AbYDOQfT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2008 12:35:19 -0400
Subject: RE: [PATCH 09/12] iwl4965: make iwl4956_send_rxon_assocasynchronous
From: Pavel Roskin <proski@gnu.org>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <D936D925018D154694D8A362EEB089200430DFD0@orsmsx416.amr.corp.intel.com>
References: <1208232974-3828-1-git-send-email-reinette.chatre@intel.com>
	 <1208232974-3828-2-git-send-email-reinette.chatre@intel.com>
	 <1208232974-3828-3-git-send-email-reinette.chatre@intel.com>
	 <1208232974-3828-4-git-send-email-reinette.chatre@intel.com>
	 <1208232974-3828-5-git-send-email-reinette.chatre@intel.com>
	 <1208232974-3828-6-git-send-email-reinette.chatre@intel.com>
	 <1208232974-3828-7-git-send-email-reinette.chatre@intel.com>
	 <1208232974-3828-8-git-send-email-reinette.chatre@intel.com>
	 <1208232974-3828-9-git-send-email-reinette.chatre@intel.com>
	 <1208232974-3828-10-git-send-email-reinette.chatre@intel.com>
	 <1208276232.14211.28.camel@dv>
	 <D936D925018D154694D8A362EEB089200430DFD0@orsmsx416.amr.corp.intel.com>
Content-Type: text/plain
Date: Tue, 15 Apr 2008 12:35:17 -0400
Message-Id: <1208277317.14211.35.camel@dv> (sfid-20080415_173525_985065_59483FA4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-04-15 at 09:22 -0700, Chatre, Reinette wrote:
> >>  static int iwl4965_send_rxon_assoc(struct iwl_priv *priv)
> > 
> > Wrong patch description.  Please swap 5 and 6 :-)
> 
> Sorry - I do not understand your comment. Could you please elaborate?

The subject was:
iwl4965: make iwl4956_send_rxon_assoc asynchronous
(you also lost a space in this reply, but it was there)

It should be:
iwl4965: make iwl4965_send_rxon_assoc asynchronous

In other words, replace 4956 with 4965 in the subject.  I hope John can
do it while applying.

-- 
Regards,
Pavel Roskin
