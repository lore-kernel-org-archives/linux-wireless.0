Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59610 "EHLO
	sipsolutions.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751696Ab3EVSXm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 May 2013 14:23:42 -0400
Message-ID: <1369246994.8207.24.camel@jlt4.sipsolutions.net> (sfid-20130522_202345_485357_CECF35C5)
Subject: Re: [PATCH 2/2] cfg80211/nl80211: Add coalesce support
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	Luciano Coelho <coelho@ti.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Wed, 22 May 2013 20:23:14 +0200
In-Reply-To: <477F20668A386D41ADCC57781B1F70430E801DC176@SC-VEXCH1.marvell.com>
References: <1369099918-4921-1-git-send-email-bzhao@marvell.com>
	 <1369099918-4921-2-git-send-email-bzhao@marvell.com>
	 <20130521232303.GX6529@pogo>
	 <477F20668A386D41ADCC57781B1F70430E0ADCE97D@SC-VEXCH1.marvell.com>
	 <1369210344.8207.0.camel@jlt4.sipsolutions.net>
	 <477F20668A386D41ADCC57781B1F70430E801DC176@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > Before you make any changes (I didn't get around to commenting on your
> > patches yesterday), I think you have to be more careful with the renames
> > to not break the API. Please provide defines or so to not break
> > compilation in the rename.
> 
> "[PATCH 1/2] cfg80211/nl80211: rename packet pattern related
> structures and enums" should have taken care of the renames. Please
> let me know if I missed anything here.

It did in the kernel, I was referring to the changes in nl80211.h, as
far as I can tell those break existing userspace tools. You should be
able to compile tools like iw and wpa_supplicant with the new nl80211.h
without changing anything in them.

johannes

