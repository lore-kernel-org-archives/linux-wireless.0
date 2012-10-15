Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38726 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab2JOMv4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2012 08:51:56 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TNk9C-0001KC-Ik
	for linux-wireless@vger.kernel.org; Mon, 15 Oct 2012 14:51:54 +0200
Message-ID: <1350305551.27801.6.camel@jlt4.sipsolutions.net> (sfid-20121015_145158_969073_19166C7E)
Subject: Re: [PATCH] mac80211: remove unimplemented mesh vendor sync
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 15 Oct 2012 14:52:31 +0200
In-Reply-To: <1349018158-22781-1-git-send-email-johannes@sipsolutions.net> (sfid-20120930_171531_154854_E0D97EA3)
References: <1349018158-22781-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20120930_171531_154854_E0D97EA3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-09-30 at 17:15 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> There's no vendor-specific mesh sync implemented
> and there don't need to be dummy handlers that
> only print messages, so remove that code. While
> at it, also constify the mesh sync ops.

Applied.

johannes

