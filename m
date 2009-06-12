Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:34786 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759298AbZFLUsA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 16:48:00 -0400
Subject: Re: [PATCH 4/8 v2.6.31 and w-t ] iwlwifi: check for channel
 location for 40MHz
From: reinette chatre <reinette.chatre@intel.com>
To: "linville@tuxdriver.com" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
In-Reply-To: <1244838175-15491-5-git-send-email-reinette.chatre@intel.com>
References: <1244838175-15491-1-git-send-email-reinette.chatre@intel.com>
	 <1244838175-15491-2-git-send-email-reinette.chatre@intel.com>
	 <1244838175-15491-3-git-send-email-reinette.chatre@intel.com>
	 <1244838175-15491-4-git-send-email-reinette.chatre@intel.com>
	 <1244838175-15491-5-git-send-email-reinette.chatre@intel.com>
Content-Type: text/plain
Date: Fri, 12 Jun 2009 13:55:06 -0700
Message-Id: <1244840106.20900.497.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

On Fri, 2009-06-12 at 13:22 -0700, Chatre, Reinette wrote:
> From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> 
> for both mixed and pure 40MHz, need to check for valid channel location.
> if the specified channel not allow the channel location requested
> (ABOVE, BELOW), then reject the Fat channel access
> 
> This fixes http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1988

To be more accurate ... patches 2, 3, and 4 combine to address this bug.

Reinette


