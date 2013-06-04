Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:57081 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab3FDKxH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 06:53:07 -0400
Message-ID: <1370343182.8287.13.camel@jlt4.sipsolutions.net> (sfid-20130604_125311_350924_43F47998)
Subject: Re: [PATCH] mac80211: Use IEEE80211_TX_CTL_REQ_TX_STATUS on
 nullframes
From: Johannes Berg <johannes@sipsolutions.net>
To: Pontus Fuchs <pontus.fuchs@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 04 Jun 2013 12:53:02 +0200
In-Reply-To: <1370342692-3191-1-git-send-email-pontus.fuchs@gmail.com> (sfid-20130604_124527_009608_73846136)
References: <1370342692-3191-1-git-send-email-pontus.fuchs@gmail.com>
	 (sfid-20130604_124527_009608_73846136)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-06-04 at 12:44 +0200, Pontus Fuchs wrote:
> The connection monitor needs to know the tx status of
> nullframes to work properly.

Applied.

johannes

