Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46919 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab2F1SDH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 14:03:07 -0400
Message-ID: <1340906581.4491.46.camel@jlt3.sipsolutions.net> (sfid-20120628_200312_152031_43B5D967)
Subject: Re: [RFC 60g 1/5] wireless: add 802.11ad (60gHz band)
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Thu, 28 Jun 2012 20:03:01 +0200
In-Reply-To: <1340882220-31768-2-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20120628_131740_615363_14B4E645)
References: <1340882220-31768-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1340882220-31768-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 (sfid-20120628_131740_615363_14B4E645)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-06-28 at 14:16 +0300, Vladimir Kondratiev wrote:

> @@ -60,8 +70,12 @@ int ieee80211_frequency_to_channel(int freq)
>  		return (freq - 2407) / 5;
>  	else if (freq >= 4910 && freq <= 4980)
>  		return (freq - 4000) / 5;
> -	else
> +	else if (freq <= 6000) /* TODO: check band 5.2 upper limit */

Looks fine, but whose TODO is this? :-)

johannes

