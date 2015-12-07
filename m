Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from postler.einfach.org ([5.9.2.179]:49511 "EHLO
	postler.einfach.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728AbbLGQNd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Dec 2015 11:13:33 -0500
Subject: Re: [PATCH] rtlwifi: fix gigantic memleak in rtl_usb
To: Peter Wu <peter@lekensteyn.nl>,
	Larry Finger <Larry.Finger@lwfinger.net>
References: <1449424677-3140-1-git-send-email-peter@lekensteyn.nl>
 <5664981C.1040704@lwfinger.net> <20151206213926.GA30777@al>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
From: Bruno Randolf <br1@einfach.org>
Message-ID: <5665AE17.8010601@einfach.org> (sfid-20151207_171357_298534_8D69D9F0)
Date: Mon, 7 Dec 2015 16:04:39 +0000
MIME-Version: 1.0
In-Reply-To: <20151206213926.GA30777@al>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/06/2015 09:39 PM, Peter Wu wrote:
>>> While using the rtl8192cu driver in monitor mode, somehow 5G of memory
>>> was permanently lost (observable via the Available column in `free -m`).
>>>
>>> This issue has existed since the introduction of this driver in v2.6.x,

One more reason to switch to rtl8xxxu as soon as possible...

bruno

