Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:50271 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592Ab3DRNEG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Apr 2013 09:04:06 -0400
Message-ID: <516FEF43.2030404@openwrt.org> (sfid-20130418_150411_176733_09F82B5C)
Date: Thu, 18 Apr 2013 15:04:03 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Karl Beldan <karl.beldan@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: Re: [PATCH v2 2/2] mac80211: minstrel_ht: initialize rates selection
References: <1366287981-24134-1-git-send-email-karl.beldan@gmail.com> <1366287981-24134-2-git-send-email-karl.beldan@gmail.com> <20130418124050.GD8638@magnum.frso.rivierawaves.com>
In-Reply-To: <20130418124050.GD8638@magnum.frso.rivierawaves.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-04-18 2:40 PM, Karl Beldan wrote:
> Johannes, Felix,
> 
> This seems to me like an important enough issue to IMHO, make it into
> 3.9/-stable. But since we only have a few days before Linus tags the 3.9
> I understand the boldness of the thought.
I'm not sure it's important enough for 3.9. Is disabling MCS0 really
that common?

- Felix

