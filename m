Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:65115 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828AbYKFBDP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 20:03:15 -0500
Subject: Re: [PATCH] ipw2200: make assocaittion only if SSID is known.
From: Zhu Yi <yi.zhu@intel.com>
To: Alexey Fisher <bug-track@fisher-privat.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"rjw@sisk.pl" <rjw@sisk.pl>,
	"kernel-testers@vger.kernel.org" <kernel-testers@vger.kernel.org>
In-Reply-To: <1225874758-5948-1-git-send-email-bug-track@fisher-privat.net>
References: <1225874758-5948-1-git-send-email-bug-track@fisher-privat.net>
Content-Type: text/plain
Date: Thu, 06 Nov 2008 09:03:51 +0800
Message-Id: <1225933431.2604.95.camel@debian.sh.intel.com> (sfid-20081106_020319_166591_075715E1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-11-05 at 16:45 +0800, Alexey Fisher wrote:
> 'iwconfig eth1 channel 6' would trigger association to _something_, 
> which is wrong.  Changing the channel should (and does) trigger
> reassociation, 
> but only if there is an SSID to associate with.
> 
> Signed-off-by: Alexey Fisher <bug-track@fisher-privat.net>

Acked-by: Zhu Yi <yi.zhu@intel.com>

Thanks,
-yi

