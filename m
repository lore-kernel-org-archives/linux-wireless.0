Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50219 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306AbbAUQgC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2015 11:36:02 -0500
Message-ID: <1421858158.1900.17.camel@sipsolutions.net> (sfid-20150121_173606_460838_ECEC5A69)
Subject: Re: [PATCH 3/3] mwifiex: selectively choose ext_scan support
From: Johannes Berg <johannes@sipsolutions.net>
To: Avinash Patil <patila@marvell.com>
Cc: linux-wireless@vger.kernel.org, akarwar@marvell.com,
	cluo@marvell.com, yogeshp@marvell.com, nishants@marvell.com,
	frankh@marvell.com
Date: Wed, 21 Jan 2015 17:35:58 +0100
In-Reply-To: <1421858531-4536-3-git-send-email-patila@marvell.com> (sfid-20150121_121353_128877_AC22EEF3)
References: <1421858531-4536-1-git-send-email-patila@marvell.com>
	 <1421858531-4536-3-git-send-email-patila@marvell.com>
	 (sfid-20150121_121353_128877_AC22EEF3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-01-21 at 22:12 +0530, Avinash Patil wrote:

> +	u8 ext_scan_support;

bool.

johannes

