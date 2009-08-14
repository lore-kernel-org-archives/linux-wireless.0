Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sirokuusama.dnainternet.net ([83.102.40.133]:35972 "EHLO
	sirokuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755263AbZHNQFl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 12:05:41 -0400
Message-ID: <20090814190539.25214ckjvpb30f28@hayate.sektori.org>
Date: Fri, 14 Aug 2009 19:05:39 +0300
From: "Jussi Kivilinna" <jussi.kivilinna@mbnet.fi>
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: "Zhu Yi" <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] cfg80211: set SME state machine correctly for roam
	event
References: <1250155399-17847-1-git-send-email-yi.zhu@intel.com>
	<1250157249.21250.0.camel@johannes.local>
In-Reply-To: <1250157249.21250.0.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting "Johannes Berg" <johannes@sipsolutions.net>:

> On Thu, 2009-08-13 at 17:23 +0800, Zhu Yi wrote:
>> When we receive a successful status in CFG80211_SME_CONNECTED state,
>> it is a roam event. We should mark it as a success result.
>
> But there's a cfg80211_roamed() call for that? Can the driver not tell
> the difference? It also sends a different event (ROAMED rather than
> CONNECTED) to userspace.
>

rndis sends 'media connect' indication when device  
associates/reassociates/"roams and associates with new AP". Specs also  
say that "must not make a media disconnect indication when  
reassociating or roaming".

-Jussi

