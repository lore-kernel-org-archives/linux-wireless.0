Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:60215 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326Ab2BOSxg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Feb 2012 13:53:36 -0500
Message-ID: <4F3BFF2B.8080706@openwrt.org> (sfid-20120215_195339_228617_DDA2BE7E)
Date: Wed, 15 Feb 2012 19:53:31 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, mcgrof@qca.qualcomm.com,
	magnus.maatta@logica.com
Subject: Re: [PATCH 3.3] ath9k_hw: prevent writes to const data on AR9160
References: <1329330680-62602-1-git-send-email-nbd@openwrt.org> <20120215183047.GD4379@tuxdriver.com>
In-Reply-To: <20120215183047.GD4379@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-02-15 7:30 PM, John W. Linville wrote:
> Do you have a link to the reported crash?
It was reported on IRC, the trace is here: http://pastebin.com/wvxXwLs4

- Felix
