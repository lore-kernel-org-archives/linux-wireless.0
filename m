Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50001 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab1JGHR7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Oct 2011 03:17:59 -0400
Subject: Re: PATCH] mac80211: set no_cck also for hw_scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
In-Reply-To: <CAFED-j=0-J_H0g3tZoDAX2q8VVFzYfs2n3im07vWkKC_wdh_bA@mail.gmail.com> (sfid-20111007_085640_732145_F397222C)
References: <CAFED-j=0-J_H0g3tZoDAX2q8VVFzYfs2n3im07vWkKC_wdh_bA@mail.gmail.com>
	 (sfid-20111007_085640_732145_F397222C)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Oct 2011 09:17:54 +0200
Message-ID: <1317971874.3988.0.camel@jlt3.sipsolutions.net> (sfid-20111007_091802_406788_D716F5D1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-10-07 at 08:56 +0200, Janusz Dziedzic wrote:
> In case we are using hw_scan we should also
> send no_cck information to lower layer.


Missing Signed-off-by, but I already submitted a very similar patch a
few days ago.

johannes


