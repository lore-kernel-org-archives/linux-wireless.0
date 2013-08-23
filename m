Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39222 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946Ab3HWOHQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Aug 2013 10:07:16 -0400
Message-ID: <1377266832.14021.38.camel@jlt4.sipsolutions.net> (sfid-20130823_160721_242139_5282D272)
Subject: Re: [PATCH v14 1/2] cfg80211: add 'flags' to cfg80211_rx_mgmt()
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Date: Fri, 23 Aug 2013 16:07:12 +0200
In-Reply-To: <1376567489-1863-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1376567489-1863-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1376567489-1863-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-08-15 at 14:51 +0300, Vladimir Kondratiev wrote:
> Flags intended to report various auxiliary information.
> Introduced flag NL80211_RXMGMT_FLAG_REPLIED to report
> whether frame was replied by the device/driver.

Applied, with some small changes.

johannes

