Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59633 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758760AbbCDIQo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2015 03:16:44 -0500
Message-ID: <1425456998.1810.3.camel@sipsolutions.net> (sfid-20150304_091650_674880_D2E167AC)
Subject: Re: [PATCH v2 3/4] mac80211: initialize rate control earlier for
 tdls station
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: Marek Puzyniak <marek.puzyniak@tieto.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath10k@lists.infradead.org
Date: Wed, 04 Mar 2015 09:16:38 +0100
In-Reply-To: <CA+XVXfdu2fCLXBP1VkMOX9nnoqCiH+h=pwzGAQ2KkBrf-H9MCQ@mail.gmail.com> (sfid-20150303_110729_103523_A070BCE6)
References: <1424850911-21017-1-git-send-email-marek.puzyniak@tieto.com>
	 <1424850911-21017-4-git-send-email-marek.puzyniak@tieto.com>
	 <1425041427.1960.1.camel@sipsolutions.net>
	 <CA+XVXfchZ+L1iH47S=rM04vJbjBSKA4O8TYuhEkfZuLpNb9QDA@mail.gmail.com>
	 <1425374299.2450.18.camel@sipsolutions.net>
	 <CA+XVXffHENxD3z9dTn_LC9c7Ot0Q4FgyEoHLjdeiDTFWQGuF9w@mail.gmail.com>
	 <1425377192.2450.34.camel@sipsolutions.net>
	 <CA+XVXfdu2fCLXBP1VkMOX9nnoqCiH+h=pwzGAQ2KkBrf-H9MCQ@mail.gmail.com>
	 (sfid-20150303_110729_103523_A070BCE6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-03-03 at 12:07 +0200, Arik Nemtsov wrote:

> > And doing so would also address the nss problem, right? IIRC that's done
> > in the rate control init inline.
> 
> Right.

Can one of you (Marek/Arik) send a combined patch then please? :)

johannes

