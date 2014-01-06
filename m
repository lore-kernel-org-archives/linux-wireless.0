Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42950 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbaAFOtF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 09:49:05 -0500
Message-ID: <1389019739.5891.16.camel@jlt4.sipsolutions.net> (sfid-20140106_154908_942816_7AF404A2)
Subject: Re: [PATCH] mac80211: Fix the buffer length in debugfs for smps
From: Johannes Berg <johannes@sipsolutions.net>
To: Chaitanya T K <chaitanya.mgit@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 06 Jan 2014 15:48:59 +0100
In-Reply-To: <1388869583-2767-1-git-send-email-chaitanya.mgit@gmail.com> (sfid-20140104_220642_177035_9496A63E)
References: <1388869583-2767-1-git-send-email-chaitanya.mgit@gmail.com>
	 (sfid-20140104_220642_177035_9496A63E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-01-05 at 02:36 +0530, Chaitanya T K wrote:
> This was blocking sending SMPS action frames 
> through debugfs.

I don't see any issue here, explain.

johannes

