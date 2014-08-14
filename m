Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aurora.create-net.org ([193.206.22.116]:59220 "EHLO
	aurora.create-net.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754791AbaHNMwd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2014 08:52:33 -0400
Message-ID: <53ECB10E.6040908@create-net.org> (sfid-20140814_145239_939374_9664BC85)
Date: Thu, 14 Aug 2014 14:52:30 +0200
From: Roberto Riggio <roberto.riggio@create-net.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: About the TSFT field
References: <53EB355E.6090508@create-net.org>		 (sfid-20140813_120259_727542_9924FF23) <1407924311.21220.28.camel@jlt4.sipsolutions.net>	 <53EBA16F.9070305@create-net.org> <1407954545.21220.40.camel@jlt4.sipsolutions.net>
In-Reply-To: <1407954545.21220.40.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 13/08/14 20:29, Johannes Berg wrote:
> On Wed, 2014-08-13 at 19:33 +0200, Roberto Riggio wrote:
> That behaviour is implemented, but it's not guaranteed that the TSF will
> be used for the radiotap timestamp field. In fact radiotap isn't really
> specified to be used while operating, so it seems to me that any
> free-running clock with the right frequency (TUs) would be acceptable.

Do you (or somebody else on this ML) happen to know if TSF is used for the
radiotap TS for the ath9k driver?

> In that sense, the only real use for the timestamp field (barring
> external information, like knowing what your driver does) would be for
> relative time inside a single capture file.

Like above, does anybody know if the ath9k driver synchronizes with other
devices in ad hoc mode in the network.

> johannes
r.
