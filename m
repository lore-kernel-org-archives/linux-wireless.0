Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37611 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755312Ab3FKNCT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 09:02:19 -0400
Message-ID: <1370955736.8356.47.camel@jlt4.sipsolutions.net> (sfid-20130611_150226_531324_672C1594)
Subject: Re: [PATCHv5 1/4] mac80211: make mgmt_tx accept a NULL channel
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <ordex@autistici.org>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Date: Tue, 11 Jun 2013 15:02:16 +0200
In-Reply-To: <1370953203-4086-1-git-send-email-ordex@autistici.org>
References: <1370953203-4086-1-git-send-email-ordex@autistici.org>
Content-Type: text/plain
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Applied all, but I fixed your locking.

johannes

