Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:58623 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754254AbXGABsM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jun 2007 21:48:12 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [WIP] mac80211: kill mgmt interface
Date: Sun, 1 Jul 2007 04:48:06 +0300
Message-ID: <D0122E209EBF8D4CAB38EC6A8AF244E502C6BFBE@hasmsx412.ger.corp.intel.com>
In-Reply-To: <20070622151514.028a644d@griffin.suse.cz>
From: "Cohen, Guy" <guy.cohen@intel.com>
To: "Jiri Benc" <jbenc@suse.cz>, "Joerg Pommnitz" <pommnitz@yahoo.com>
Cc: <linux-wireless@vger.kernel.org>,
	"Johannes Berg" <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Jiri Benc wrote:
> > Can one run multiple MLME (e.g. hostapd) instances to run multiple
> virtual master mode interfaces
> > for different networks? With different BSSID?
> 
> I don't think that would be ever possible when using monitor
> interfaces.
> 
> On the other hand, it doesn't make much sense to support that. The
> interfaces are not completely independent, e.g. you cannot tune to
> different channels on different virtual interfaces. Therefore, at
least
> a minimal knowledge about virtual interfaces would be needed in more
> complicated user space MLMEs.

This is a required feature for Access Points (multiple BSSID).
