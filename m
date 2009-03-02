Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.188]:3354 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbZCBSYv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2009 13:24:51 -0500
Received: by ti-out-0910.google.com with SMTP id d10so2894211tib.23
        for <linux-wireless@vger.kernel.org>; Mon, 02 Mar 2009 10:24:48 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18860.9287.532112.28606@gargle.gargle.HOWL> (sfid-20090302_192454_547988_4C769018)
Date: Mon, 2 Mar 2009 23:54:07 +0530
To: reinette chatre <reinette.chatre@intel.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>
Subject: Re: [PATCH 2/6] iwl3945: synchronize timestamp with uCode
In-Reply-To: <1236017466.18288.96.camel@rc-desk>
References: <1235780484-27979-1-git-send-email-reinette.chatre@intel.com>
	<1235780484-27979-2-git-send-email-reinette.chatre@intel.com>
	<1235780484-27979-3-git-send-email-reinette.chatre@intel.com>
	<18856.39984.142504.861070@gargle.gargle.HOWL>
	<1236017466.18288.96.camel@rc-desk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

reinette chatre wrote:
> > This won't work, since the timestamp in the beacon isn't being updated in mac80211.
> > See the 'IBSS Issues' thread. I attached a quick patch there.
> 
> Thanks for spotting this. There is thus not a problem with this specific
> patch ... just the information it depends on, which you now fixed. Are
> you going to send your fix for inclusion ?

Yep, will send a patch soon.

Sujith
