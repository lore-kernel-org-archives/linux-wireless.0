Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55412 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512AbbKCJ26 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2015 04:28:58 -0500
Message-ID: <1446542934.29010.2.camel@sipsolutions.net> (sfid-20151103_103231_895171_C885E327)
Subject: Re: [PATCH] nl80211: Fix potential memory leak from parse_acl_data
From: Johannes Berg <johannes@sipsolutions.net>
To: Ola Olsson <ola1olsson@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Ola Olsson <ola.olsson@sonymobile.com>
Date: Tue, 03 Nov 2015 10:28:54 +0100
In-Reply-To: <1446098698-10079-1-git-send-email-ola1olsson@gmail.com> (sfid-20151029_070502_508027_173CC484)
References: <1446098698-10079-1-git-send-email-ola1olsson@gmail.com>
	 (sfid-20151029_070502_508027_173CC484)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-10-29 at 07:04 +0100, Ola Olsson wrote:
> If parse_acl_data succeeds but the subsequent parsing of smps
> attributes fails, there will be a memory leak due to early returns.
> Fix that.
> 
Applied, thanks!

johannes
