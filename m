Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36481 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297Ab2HTMdI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2012 08:33:08 -0400
Message-ID: <1345465984.4459.28.camel@jlt3.sipsolutions.net> (sfid-20120820_143312_417409_8B5B5875)
Subject: Re: [PATCH] carl9170: report A-MPDU status
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Date: Mon, 20 Aug 2012 14:33:04 +0200
In-Reply-To: <20120731211916.1FFC1100193@blech.mobile> (sfid-20120731_231934_107766_36BF003B)
References: <1343734541-14934-1-git-send-email-johannes@sipsolutions.net>
	 <20120731211916.1FFC1100193@blech.mobile>
	 (sfid-20120731_231934_107766_36BF003B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-07-31 at 23:12 +0200, Christian Lamparter wrote:
> Because the hardware reports whenever an frame
> was either at the start, in the middle or at
> the end of a A-MPDU, we can easily report the
> information for radiotap.

John, you can pick this up after you pull from me, I've included the
prerequisite patches now.

johannes

