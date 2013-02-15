Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59573 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161440Ab3BOMq1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 07:46:27 -0500
Message-ID: <1360932381.15040.11.camel@jlt4.sipsolutions.net> (sfid-20130215_135258_365798_6850667D)
Subject: Re: [PATCH 1/3] mac80211: move mesh sync beacon handler into
 neighbour_update
From: Johannes Berg <johannes@sipsolutions.net>
To: marco@cozybit.com
Cc: mcgrof@qca.qualcomm.com, jouni@qca.qualcomm.com,
	vthiagar@qca.qualcomm.com, senthilb@qca.qualcomm.com,
	linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	ath9k-devel@lists.ath9k.org
Date: Fri, 15 Feb 2013 13:46:21 +0100
In-Reply-To: <3fance.mi9hwg.2rw1te-qmf@mx.google.com> (sfid-20130215_134116_713607_1FD8E99F)
References: <1360928446-543-1-git-send-email-marco@cozybit.com>
		 (sfid-20130215_124056_325990_55BC105E) <1360930499.15040.7.camel@jlt4.sipsolutions.net>
	 <3fance.mi9hwg.2rw1te-qmf@mx.google.com>
	 (sfid-20130215_134116_713607_1FD8E99F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-02-15 at 12:40 +0000, marco@cozybit.com wrote:
> Please check again. The comment is split in two and placed on the respective new positions.

Yeah, I see, the API is just total shit. First passing the TSF and then
calculating it to override? Why not do the calculation outside the API
always?

johannes

