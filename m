Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36058 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719Ab2KZPJ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 10:09:28 -0500
Message-ID: <1353942595.2800.2.camel@jlt4.sipsolutions.net> (sfid-20121126_160935_216697_3E558961)
Subject: Re: [RFC] mac80211: add debugfs file for current tx rate
From: Johannes Berg <johannes@sipsolutions.net>
To: saravanad@posedge.com
Cc: linux-wireless@vger.kernel.org
Date: Mon, 26 Nov 2012 16:09:55 +0100
In-Reply-To: <3cce329ee6381f0ab4dd4d86ea76c2da@posedge.com>
References: <3cce329ee6381f0ab4dd4d86ea76c2da@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-11-26 at 05:22 -0800, saravanad@posedge.com wrote:
> Add a debugfs file showing the current tx rate.
> The information available in the rc_stats file
> doesn't evidently provides us the current tx rate.
> This patch adds the support for the same.

I don't see any value in this, you can just do "iw station dump" to get
the information.

johannes

