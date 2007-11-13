Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:33051 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565AbXKMQDT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2007 11:03:19 -0500
MIME-Version: 1.0
Subject: RE: [PATCH 07/14] mac80211: adding 802.11n configuration flows
Date: Tue, 13 Nov 2007 17:58:54 +0200
Message-ID: <1879838866982C46A9CB3D56BA49ADEB0403BC2B@hasmsx411.ger.corp.intel.com> (sfid-20071113_160343_882296_B157CCD6)
In-Reply-To: <1194885460.5229.53.camel@johannes.berg>
From: "Rindjunsky, Ron" <ron.rindjunsky@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	<flamingice@sourmilk.net>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> Now, I began to work on a solution for this problem (please refer to
my
>> RFC "mac80211: [RFC] adding bss_config to low level driver ops"), in
>> which I wanted to unite all IE changes into one callback. 

> Oh right, I completely forgot about that, sorry. I should take another
> look, or would you like to repost that?

No problems, I'll re-base it to current code and re-send it

Ron

>> If Michael is
>> already working on a more general solution for all "config" callbacks
I
>> would be happy to contribute to his effort, or even continue my RFC
to a
>> more solid patch, but until this will occur I just used similar
approach
>> to already existing callbacks.

> I don't really know if he's working on it and I guess that if he is
he'd
> take your work as a base.

> johannes
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
