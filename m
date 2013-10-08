Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:32922 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704Ab3JHLAC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Oct 2013 07:00:02 -0400
Message-ID: <1381229996.13359.6.camel@jlt4.sipsolutions.net> (sfid-20131008_130009_894317_69B6230A)
Subject: Re: pull-request: iwlwifi-next 2013-10-07
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 08 Oct 2013 12:59:56 +0200
In-Reply-To: <1381139793.13586.18.camel@jlt4.sipsolutions.net> (sfid-20131007_115641_213838_DC2EAF34)
References: <1381139793.13586.18.camel@jlt4.sipsolutions.net>
	 (sfid-20131007_115641_213838_DC2EAF34)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please hold off on this,

>       iwlwifi: mvm: Add device wide power command

This commit causes a regression in monitor mode.

johannes

