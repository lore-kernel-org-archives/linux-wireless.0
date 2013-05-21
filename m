Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:64274 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab3EUXXH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 May 2013 19:23:07 -0400
Cc: <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	Luciano Coelho <coelho@ti.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Tue, 21 May 2013 16:23:03 -0700
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: Bing Zhao <bzhao@marvell.com>
Subject: Re: [PATCH 2/2] cfg80211/nl80211: Add coalesce support
Message-ID: <20130521232303.GX6529@pogo> (sfid-20130522_012327_331504_854D7FC6)
References: <1369099918-4921-1-git-send-email-bzhao@marvell.com>
 <1369099918-4921-2-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1369099918-4921-2-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 20, 2013 at 06:31:58PM -0700, Bing Zhao wrote:
> From: Amitkumar Karwar <akarwar@marvell.com>
> 
> Add set/get configuration support for packet coalesce.
> 
> This feature needs to be advertised during driver initialization.
> Drivers can do required hardware settings based on user configuration.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Bing Zhao <bzhao@marvell.com>

I see nothing documenting clearly what this "coalesce" does.
Can you elaborate quite a bit both on the commit log and also
the documentation on nl80211.h what this is exactly? It would
also be good for you to express on your previous patch why
you want the rename.

If you add this also can you please be sure to update the wiki
for iw to document support for this?

  Luis
