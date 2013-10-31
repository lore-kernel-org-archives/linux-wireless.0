Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:47787 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932Ab3JaQfB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Oct 2013 12:35:01 -0400
Message-ID: <1383237294.14302.5.camel@jlt4.sipsolutions.net> (sfid-20131031_173506_944889_85033697)
Subject: Re: [PATCH 00/14] wlan: consolidate passive-scan and no-ibss flags
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	janusz.dziedzic@tieto.com, smihir@qti.qualcomm.com,
	tushnimb@qca.qualcomm.com
Date: Thu, 31 Oct 2013 17:34:54 +0100
In-Reply-To: <1382376158-25586-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20131021_192242_751436_1500AA56)
References: <1382376158-25586-1-git-send-email-mcgrof@do-not-panic.com>
	 (sfid-20131021_192242_751436_1500AA56)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-10-21 at 19:22 +0200, Luis R. Rodriguez wrote:
> John, Johannes,
> 
> This series addresses consolidating passive-scan and no-ibss flags.
> Since its crosses over drivers I'll let you guys decide what tree
> this goes into.

Alright, I've applied this, but in one single big patch, and I've redone
(most of) the driver updates using spatch.

There were conflicts applying the patch, so most likely John will get
conflicts when merging my tree. I've added the spatches to the commit
log so that should be easy to resolve.

johannes

