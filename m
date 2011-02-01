Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3046 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859Ab1BAKCo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Feb 2011 05:02:44 -0500
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] mac80211: deauthenticate STAs before suspend
References: <ce260d15f83b54d9a328a2d636cf9a4e@rss.opera.com>
Date: Tue, 1 Feb 2011 11:02:28 +0100
MIME-Version: 1.0
From: "Arend van Spriel" <arend@broadcom.com>
Message-ID: <op.vp7x6et33ri7v4@arend-laptop>
In-Reply-To: <ce260d15f83b54d9a328a2d636cf9a4e@rss.opera.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed;
 delsp=yes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> IOW, I'd rather leave it as is. It seems there isn't really a problem,
> but rather a perceived inconsistency that is being "fixed"?

Agree. It may be considered a fix from a particular user-space application
perspective (ie. NetworkManager) but from standards perspective there is
no reason to do this.

>
> johannes
>

Gr. AvS

