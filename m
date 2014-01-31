Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:52242 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238AbaAaOLZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jan 2014 09:11:25 -0500
Message-ID: <1391177479.4141.23.camel@jlt4.sipsolutions.net> (sfid-20140131_151128_617707_AE9AE5A8)
Subject: Re: [PATCH v3 3/6] cfg80211: Enable GO operation on additional
 channels
From: Johannes Berg <johannes@sipsolutions.net>
To: Ilan Peer <ilan.peer@intel.com>
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
Date: Fri, 31 Jan 2014 15:11:19 +0100
In-Reply-To: <1390818118-27261-4-git-send-email-ilan.peer@intel.com> (sfid-20140127_112147_514798_01405A03)
References: <1390818118-27261-1-git-send-email-ilan.peer@intel.com>
	 <1390818118-27261-4-git-send-email-ilan.peer@intel.com>
	 (sfid-20140127_112147_514798_01405A03)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-01-27 at 12:21 +0200, Ilan Peer wrote:

> It is assumed that such restrictions are enforced by user space.
> Furthermore, it is assumed, that if the conditions that allowed for
> the operation of the GO on such a channel change, i.e., the station
> interface disconnected from the AP, it is the responsibility of user
> space to evacuate the GO from the channel.

For the latter here, don't we need some sort of flag with userspace
saying "trust me, I know what I'm doing"? Or put another way - how does
this not make us break compliance when running with old versions of
wpa_supplicant?

johannes

