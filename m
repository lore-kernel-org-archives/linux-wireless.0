Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34908 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781Ab2FTGNp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 02:13:45 -0400
Message-ID: <1340172817.4655.3.camel@jlt3.sipsolutions.net> (sfid-20120620_081349_178237_07CAE090)
Subject: Re: [RFC v2] cfg80211: 802.11ac change
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 20 Jun 2012 08:13:37 +0200
In-Reply-To: <952C5D5D0470AE4FB7D8A75C6ADC71CA0A4FA6@mbx022-e1-nj-10.exch022.domain.local>
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0A4FA6@mbx022-e1-nj-10.exch022.domain.local>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-06-05 at 10:42 +0000, Mahesh Palivela wrote:
> nl80211 change to push hw VHT caps and new structs, ieee defines per Draft 2.1 AC spec.

Sorry, I somehow missed this RFC. Could you split the patch into
ieee80211.h changes and cfg80211 changes? I'd like to merge the
ieee80211.h changes soon so everyone has them to start working with, and
the cfg80211/nl80211 might need more discussion.

johannes


