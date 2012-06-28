Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46945 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab2F1SH5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 14:07:57 -0400
Message-ID: <1340906876.4491.49.camel@jlt3.sipsolutions.net> (sfid-20120628_200801_392319_04276B50)
Subject: Re: [RFC 60g 5/5] wireless: bitrate calculation for 60g
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Thu, 28 Jun 2012 20:07:56 +0200
In-Reply-To: <1340882220-31768-6-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20120628_131808_978759_C50A6118)
References: <1340882220-31768-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1340882220-31768-6-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 (sfid-20120628_131808_978759_C50A6118)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-06-28 at 14:17 +0300, Vladimir Kondratiev wrote:

> +static u16 cfg80211_calculate_bitrate_60g(struct rate_info *rate)

You didn't test this function :-)

johannes

