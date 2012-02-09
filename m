Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46188 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab2BIIF2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Feb 2012 03:05:28 -0500
Message-ID: <4F337E26.6030901@sipsolutions.net> (sfid-20120209_090531_541752_BCE5AF1D)
Date: Thu, 09 Feb 2012 09:04:54 +0100
From: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: Arend van Spriel <arend@broadcom.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] mac80211: minstrel_ht: fix NULL pointer dereference
 during auth/assoc
References: <1328705077-31360-1-git-send-email-arend@broadcom.com> <4F329DE5.20408@openwrt.org> <4F32A263.5050909@broadcom.com> <4F32AB79.9040307@openwrt.org> <4F32B111.8020006@openwrt.org> <4F32B251.8090101@broadcom.com> <4F32B3A5.5020903@openwrt.org>
In-Reply-To: <4F32B3A5.5020903@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2/8/2012 6:40 PM, Felix Fietkau wrote:
>> I will test it. So basically we don't want to do rate control for
>> management frames like AUTH and ASSOC?
> Right. That's already handled like this by the current code, only the tx
> status path was left out (probably accidentally).

Yes, my mistake, I forgot about TX status path. Thanks everyone for 
taking care of this!

johannes
