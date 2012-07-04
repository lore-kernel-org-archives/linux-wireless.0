Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41341 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933490Ab2GDHy2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2012 03:54:28 -0400
Message-ID: <1341388464.4482.1.camel@jlt3.sipsolutions.net> (sfid-20120704_095431_883768_321734C3)
Subject: Re: [PATCH v1 0/2] High bitrate support
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Wed, 04 Jul 2012 09:54:24 +0200
In-Reply-To: <1341386520-25244-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1341386520-25244-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-07-04 at 10:21 +0300, Vladimir Kondratiev wrote:
>                                                                                                                                                                                    
> Idea is to report (in nl80211) both old and new values,
> or only new if it not fits into u16.
> User space tools encouraged to migrate to the new bitrate.

Could you also send me a patch for iw to use it? :-)

johannes

