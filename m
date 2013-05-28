Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:56565 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933862Ab3E1M2V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 May 2013 08:28:21 -0400
Message-ID: <1369744097.8548.2.camel@jlt4.sipsolutions.net> (sfid-20130528_142824_500215_246F934F)
Subject: Re: [PATCH 0/2] wil6210: fix for wdev->sme_state
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Tue, 28 May 2013 14:28:17 +0200
In-Reply-To: <1369743473-7243-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1369743473-7243-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-05-28 at 15:17 +0300, Vladimir Kondratiev wrote:
> Here goes patch that Johannes asked for, where wil6210 stop using
> wdev->sme_state. Also, included is small patch fixing wrong channel
> when starting AP

Thanks!

Also a fix for a wil_status_dontscan status bit leak, if wmi_send()
fails :-)

johannes

