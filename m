Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:38040 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896AbYIKXuE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 19:50:04 -0400
Subject: Re: [PATCH] mac80211 hwsim: make radio list dynamic
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <1221172622.5956.10.camel@johannes.berg>
References: <1221172622.5956.10.camel@johannes.berg>
Content-Type: text/plain
Date: Fri, 12 Sep 2008 03:50:33 +0200
Message-Id: <1221184233.11498.4.camel@californication> (sfid-20080912_015008_052720_D545006B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> This paves the way for dynamic radio additions while the module
> is loaded. Also restrict the number of radios to 100 because
> creating that many already takes forever.

any plans to do this via configfs in a fully dynamic way. This would
allow us to emulate hardware hotplug :)

Regards

Marcel


