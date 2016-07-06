Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39964 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178AbcGFLJk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 07:09:40 -0400
Message-ID: <1467803374.26633.0.camel@sipsolutions.net> (sfid-20160706_130943_280413_494E8BB8)
Subject: Re: [PATCH] nl80211: Move ACL parsing later to avoid a possible
 memory leak
From: Johannes Berg <johannes@sipsolutions.net>
To: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, jouni@qca.qualcomm.com,
	usdutt@qti.qualcomm.com
Date: Wed, 06 Jul 2016 13:09:34 +0200
In-Reply-To: <1467706491-22859-1-git-send-email-pkushwah@qti.qualcomm.com>
References: <1467706491-22859-1-git-send-email-pkushwah@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-07-05 at 13:44 +0530, Purushottam Kushwaha wrote:
> No support for pbss results in a memory leak for the acl_data
> (if parse_acl_data succeeds). Fix this by moving the ACL parsing
> later.
> 
Applied, thanks.

johannes
