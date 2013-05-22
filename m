Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:57705 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445Ab3EVIMd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 May 2013 04:12:33 -0400
Message-ID: <1369210344.8207.0.camel@jlt4.sipsolutions.net> (sfid-20130522_101238_000776_19338BA3)
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
Date: Wed, 22 May 2013 10:12:24 +0200
In-Reply-To: <477F20668A386D41ADCC57781B1F70430E0ADCE97D@SC-VEXCH1.marvell.com>
References: <1369099918-4921-1-git-send-email-bzhao@marvell.com>
	 <1369099918-4921-2-git-send-email-bzhao@marvell.com>
	 <20130521232303.GX6529@pogo>
	 <477F20668A386D41ADCC57781B1F70430E0ADCE97D@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-05-21 at 16:59 -0700, Bing Zhao wrote:

> "packet coalesce" will reuse the pattern structure (and its enum definitions) defined for
> WoWLAN. It's renamed so that both WoWLAN and Coalesce can make use of it.

Before you make any changes (I didn't get around to commenting on your
patches yesterday), I think you have to be more careful with the renames
to not break the API. Please provide defines or so to not break
compilation in the rename.

johannes

