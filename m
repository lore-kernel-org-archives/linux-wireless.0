Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52962 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbcCJGTR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2016 01:19:17 -0500
Date: Thu, 10 Mar 2016 11:48:58 +0530
From: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>,
	linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
	kvalo@codeaurora.org, Anilkumar Kolli <akolli@qti.qualcomm.com>
Subject: Re: [RFC v1] mac80211: Add support for per station rx stats histogram
Message-ID: <20160310061858.GB11345@atheros-ThinkPad-T61> (sfid-20160310_071921_577710_B47DD841)
References: <1457367809-13637-1-git-send-email-mohammed@qca.qualcomm.com>
 <1457424451.2283.2.camel@sipsolutions.net>
 <20160308094250.GA3685@atheros-ThinkPad-T61>
 <20160309163038.GA9410@atheros-ThinkPad-T61>
 <1457544468.2042.20.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1457544468.2042.20.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 09, 2016 at 06:27:48PM +0100, Johannes Berg wrote:
> On Wed, 2016-03-09 at 22:00 +0530, Mohammed Shafi Shajakhan wrote:
> > 
> > I had started studying(understand) your patch. Please
> > let me know if you have already added support for the same
> > in userspace as well, we like to use your changes and possibly
> > add any changes that addresses rx_stats histogram as well
> 
> I had a very minimal file in iw, but that's all:
> 
> https://p.sipsolutions.net/744c0854bc02c95f.txt
>
[shafi] thank you for sharing this Johannes

-shafi
