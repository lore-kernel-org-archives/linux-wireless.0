Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37241 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab2J2JJc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2012 05:09:32 -0400
Message-ID: <1351501806.10925.8.camel@jlt4.sipsolutions.net> (sfid-20121029_100936_092523_739B7AF1)
Subject: Re: [PATCH] wireless: drop invalid mesh address extension frames
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: javier@cozybit.com
Date: Mon, 29 Oct 2012 10:10:06 +0100
In-Reply-To: <1351195011-30148-1-git-send-email-johannes@sipsolutions.net> (sfid-20121025_215622_269216_205911A7)
References: <1351195011-30148-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121025_215622_269216_205911A7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-10-25 at 21:56 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The mesh header can have address extension by a 4th
> or a 5th and 6th address, but never both. Drop such
> frames in 802.11 -> 802.3 conversion.

Applied.

johannes

