Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49052 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab1EDM1y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2011 08:27:54 -0400
Subject: Re: [PATCH 01/13] nl80211: Introduce
 NL80211_MESH_SETUP_USERSPACE_AMPE
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org,
	jlopex@gmail.com
In-Reply-To: <1304467039-7730-2-git-send-email-javier@cozybit.com> (sfid-20110504_015754_712192_7878E394)
References: <1304467039-7730-1-git-send-email-javier@cozybit.com>
	 <1304467039-7730-2-git-send-email-javier@cozybit.com>
	 (sfid-20110504_015754_712192_7878E394)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 May 2011 14:27:05 +0200
Message-ID: <1304512025.3563.12.camel@jlt3.sipsolutions.net> (sfid-20110504_142757_388140_E687E0AC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-05-03 at 16:57 -0700, Javier Cardona wrote:

> These patches introduce support for Authenticated Mesh Peering Exchange
> in userspace.  The userspace daemon implements the AMPE protocol and on
> successfull completion create mesh peers and install encryption keys.

Do all combinations make sense? I mean, I can sort of see that you can
have authenticated but unsecured, but secured and unauthenticated?

johannes

