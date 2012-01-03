Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:47741 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754497Ab2ACTAs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jan 2012 14:00:48 -0500
Message-ID: <4F035028.6030207@hauke-m.de> (sfid-20120103_200051_699137_AFFCF8D5)
Date: Tue, 03 Jan 2012 19:59:52 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org,
	Luis Rodriguez <mcgrof@frijolero.org>
Subject: Re: compat-wireless patch Re: [PATCH] Enable CONFIG_RT2800{PCI,USB}_RT53XX
References: <1325604516-14280-1-git-send-email-linville@tuxdriver.com> <20120103153535.GA24318@tuxdriver.com>
In-Reply-To: <20120103153535.GA24318@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/03/2012 04:35 PM, John W. Linville wrote:
> On Tue, Jan 03, 2012 at 10:28:36AM -0500, John W. Linville wrote:
>> Signed-off-by: John W. Linville <linville@tuxdriver.com>
>> ---
>> Any reason to treat these differently than the RT35XX devices?
Some/Long time ago RT53XX devices where marked as not working in
Kconfig, now I can not find such a message any more, so I am totally
fine with this patch.

Hauke
