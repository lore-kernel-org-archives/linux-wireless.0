Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39094 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab3LBOml (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Dec 2013 09:42:41 -0500
Message-ID: <1385995357.20277.2.camel@jlt4.sipsolutions.net> (sfid-20131202_154245_011651_C768F782)
Subject: Re: [RFC] mac80211: fix rx_nss calculation for drivers with hw rc
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Date: Mon, 02 Dec 2013 15:42:37 +0100
In-Reply-To: <1385981647-4147-1-git-send-email-michal.kazior@tieto.com> (sfid-20131202_115744_274098_9362F537)
References: <1385739434.8656.0.camel@jlt4.sipsolutions.net>
	 <1385981647-4147-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20131202_115744_274098_9362F537)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-12-02 at 11:54 +0100, Michal Kazior wrote:
> Drivers with hardware rate control were given
> sta->rx_nss set to 0. This was because rx_nss
> calculation procedure was protected by hw/sw rate
> control check.

Applied.

johannes

