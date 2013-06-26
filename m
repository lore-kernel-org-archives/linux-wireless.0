Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:44783 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab3FZPEG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jun 2013 11:04:06 -0400
Message-ID: <1372259043.13529.2.camel@jlt4.sipsolutions.net> (sfid-20130626_170421_671048_5918424B)
Subject: Re: [PATCH v4 1/2] cfg80211/nl80211: rename packet pattern related
 structures and enums
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	Luciano Coelho <coelho@ti.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Wed, 26 Jun 2013 17:04:03 +0200
In-Reply-To: <1372212237-5687-1-git-send-email-bzhao@marvell.com>
References: <1372212237-5687-1-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-06-25 at 19:03 -0700, Bing Zhao wrote:
> From: Amitkumar Karwar <akarwar@marvell.com>
> 
> Currently packet patterns and it's enum/structures are used only
> for WoWLAN feature. As we intend to reuse them for new feature
> packet coalesce, they are renamed in this patch.

This looks good, applied.

johannes

