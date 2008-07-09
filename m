Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:30896 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbYGIUBl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 16:01:41 -0400
Received: by yx-out-2324.google.com with SMTP id 8so901579yxm.1
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jul 2008 13:01:41 -0700 (PDT)
Subject: Re: [PATCH 2/4] mac80211: wme.c replace QD_NUM macro with static
	inline
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1215633420.3246.47.camel@johannes.berg>
References: <1215632672.476.85.camel@brick>
	 (sfid-20080709_214438_247406_7CFB8ABA)  <1215633420.3246.47.camel@johannes.berg>
Content-Type: text/plain
Date: Wed, 09 Jul 2008 13:01:41 -0700
Message-Id: <1215633701.476.90.camel@brick> (sfid-20080709_220151_630268_F952E3A2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-07-09 at 21:57 +0200, Johannes Berg wrote:
> While I don't really disagree with this patch, let's not do it at least
> for now so we don't break davem's TX MQ rework needlessly.
> 

Sure, I'll keep an eye out for his stuff to go in and resubmit at a
later time.

Harvey

