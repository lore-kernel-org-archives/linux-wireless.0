Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:1348 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752505AbXLSN1o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 08:27:44 -0500
MIME-Version: 1.0
Subject: RE: [PATCH 7/8] mac80211: A-MPDU Rx handling DELBA requests
Date: Wed, 19 Dec 2007 15:22:40 +0200
Message-ID: <1879838866982C46A9CB3D56BA49ADEB04313AE6@hasmsx411.ger.corp.intel.com> (sfid-20071219_132747_181828_A0B0D635)
In-Reply-To: <1197985898.4885.141.camel@johannes.berg>
References: <11979070692599-git-send-email-ron.rindjunsky@intel.com> <11979070791111-git-send-email-ron.rindjunsky@intel.com> <1197915987.4885.95.camel@johannes.berg> <c85cb4470712180546x42217cbdjb7cb6457884b55fe@mail.gmail.com> (sfid-20071218_134627_430781_91173A9A) <1197985898.4885.141.camel@johannes.berg>
From: "Rindjunsky, Ron" <ron.rindjunsky@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<flamingice@sourmilk.net>,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	"Zhu, Yi" <yi.zhu@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>> yes, i am handling only Rx A-MPDU, so only initiator of the session
>> can send us delBA

> Ok, thanks for the clarification. Should we log an error if somebody
> else sends us one?

I don't think so. I have a debug print already there, and unless we deal
with an evil peer it won't happen. If we do deal with an evil opponent I
think it falls into TGw area.

> johannes
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

