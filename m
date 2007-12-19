Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:62906 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689AbXLSTAZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 14:00:25 -0500
MIME-Version: 1.0
Subject: RE: [PATCH 6/8] mac80211: A-MPDU Rx adding BAR handling capability
Date: Wed, 19 Dec 2007 20:59:07 +0200
Message-ID: <1879838866982C46A9CB3D56BA49ADEB04313CF7@hasmsx411.ger.corp.intel.com> (sfid-20071219_190027_561001_06492135)
In-Reply-To: <1198079138.4747.8.camel@johannes.berg>
References: <11979070692599-git-send-email-ron.rindjunsky@intel.com> <11979070783125-git-send-email-ron.rindjunsky@intel.com> <1197915884.4885.93.camel@johannes.berg> <c85cb4470712180545u46dc0a21obdc6d7b6c095b797@mail.gmail.com> (sfid-20071218_134627_418190_29EDCA18) <1197986001.4885.144.camel@johannes.berg> <1879838866982C46A9CB3D56BA49ADEB04313AE5@hasmsx411.ger.corp.intel.com> <1198079138.4747.8.camel@johannes.berg>
From: "Rindjunsky, Ron" <ron.rindjunsky@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<flamingice@sourmilk.net>,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	"Zhu, Yi" <yi.zhu@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > I guess we should just return NULL in all other cases here. But
please
> > enumerate the cases explicitly so that people who add new interface
> > types get warnings, i.e. don't use a default: statement in a switch
> > (interface type)
> 
> you sure you want these ugly warnings? I do prefer to put default
here.

Ok, will do. I will rebase all the patches and resend them.
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

