Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47358 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934032Ab2DLPvh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 11:51:37 -0400
Received: by obbtb18 with SMTP id tb18so2881536obb.19
        for <linux-wireless@vger.kernel.org>; Thu, 12 Apr 2012 08:51:37 -0700 (PDT)
Message-ID: <4F86FA05.5080404@lwfinger.net> (sfid-20120412_175140_912049_2F202825)
Date: Thu, 12 Apr 2012 10:51:33 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Suspicious RCU usage in mac80211
References: <4F83A6DE.7070109@lwfinger.net>   (sfid-20120410_052034_062782_82AB2FD8) <1334201497.3788.1.camel@jlt3.sipsolutions.net>  <4F865155.2000202@lwfinger.net> (sfid-20120412_055225_110383_5156780F) <1334202842.3788.10.camel@jlt3.sipsolutions.net>
In-Reply-To: <1334202842.3788.10.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/11/2012 10:54 PM, Johannes Berg wrote:
>
> What do you mean by "every time"? I wouldn't expect the timer to fire
> every time you set up aggregation etc., the timer firing is a special
> case to start with.

I meant it is intermittent, or it required some special setup that I have not 
duplicated, as I have seen the condition only once.

Larry

