Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:61306 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121AbYKGUJm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2008 15:09:42 -0500
Subject: Re: [PATCH 11/13] iwl3945 : Simplify iwl3945_send_beacon_cmd
From: reinette chatre <reinette.chatre@intel.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>
In-Reply-To: <1226081360.11596.25.camel@brick>
References: <> <1226080726-24860-1-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-2-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-3-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-4-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-5-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-6-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-7-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-8-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-9-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-10-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-11-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-12-git-send-email-reinette.chatre@intel.com>
	 <1226081360.11596.25.camel@brick>
Content-Type: text/plain
Date: Fri, 07 Nov 2008 12:10:05 -0800
Message-Id: <1226088605.1115.692.camel@rc-desk> (sfid-20081107_210949_254330_C80DE422)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-11-07 at 10:09 -0800, Harvey Harrison wrote:

> Perhaps a helpful define for these two magic mask values is called for.

yes ... the defines are actually available already ... we just need to
use it here. Will send another patch on top of this as this is not the
only spot we are using these magic values.

Reinette

