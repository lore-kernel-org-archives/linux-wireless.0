Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59428 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab3JAKZV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Oct 2013 06:25:21 -0400
Message-ID: <1380623118.14430.11.camel@jlt4.sipsolutions.net> (sfid-20131001_122524_759660_118A2D97)
Subject: Re: [PATCH] mac80211: improve default WMM parameter setting
From: Johannes Berg <johannes@sipsolutions.net>
To: Fred Zhou <fred.zy@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 01 Oct 2013 12:25:18 +0200
In-Reply-To: <1378739021-3072-1-git-send-email-fred.zy@gmail.com> (sfid-20130909_170453_757067_9E1E8251)
References: <1378739021-3072-1-git-send-email-fred.zy@gmail.com>
	 (sfid-20130909_170453_757067_9E1E8251)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-09-09 at 23:03 +0800, Fred Zhou wrote:
> Move the default setting for WMM parameters outside the for loop
> to avoid redundant assignment multiple times.

Applied.

johannes

