Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:59238 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756580AbZKBRmI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 12:42:08 -0500
Subject: Re: [PATCH 08/15] iwlwifi: move iwl_[un]init_drv to iwlagn
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1257183329.16174.3.camel@johannes.local>
References: <1256938578-9638-1-git-send-email-reinette.chatre@intel.com>
	 <1256938578-9638-9-git-send-email-reinette.chatre@intel.com>
	 <1256968603.3555.79.camel@johannes.local>
	 <1257182368.21134.13580.camel@rc-desk>
	 <1257183329.16174.3.camel@johannes.local>
Content-Type: text/plain
Date: Mon, 02 Nov 2009 09:42:11 -0800
Message-Id: <1257183732.21134.13582.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-11-02 at 09:35 -0800, Johannes Berg wrote:
> Anyway, I agree with moving code, but it
> seems it could go further.

Absolutely. I perform these cleanups as I encounter (or in this case
need) them. 

Reinette


