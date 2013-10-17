Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:44048 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326Ab3JQOki (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 10:40:38 -0400
Message-ID: <1382020835.14410.16.camel@jlt4.sipsolutions.net> (sfid-20131017_164041_654870_3A935214)
Subject: Re: [PATCH] cfg80211/nl80211: Add support to report unsafe
 frequency ranges(s)
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajesh Chauhan <rajeshc@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, rodrigue@qca.qualcomm.com,
	jouni@qca.qualcomm.com
Date: Thu, 17 Oct 2013 16:40:35 +0200
In-Reply-To: <1381985833-31312-1-git-send-email-rajeshc@qca.qualcomm.com>
References: <1381985833-31312-1-git-send-email-rajeshc@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-10-16 at 21:57 -0700, Rajesh Chauhan wrote:
> Add support for WLAN driver to report unsafe frequency range(s). 

Why?

> User
> space should move SAP/P2P-GO out of those unsafe frequency range(s).
> User space may decide to continue operation on unsafe frequency but in
> such case there might be impact on performance because of interference.

SAP? I don't think SAP will move - they're pretty stuck in Walldorf :P

This is pretty strange patch, and very little justification.

"Unsafe" is also a really bad word.

johannes

