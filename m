Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:35083 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402Ab0K3PeU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Nov 2010 10:34:20 -0500
Received: by gwj20 with SMTP id 20so2757178gwj.19
        for <linux-wireless@vger.kernel.org>; Tue, 30 Nov 2010 07:34:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1291116244.3624.10.camel@jlt3.sipsolutions.net>
References: <1291111467-10531-1-git-send-email-eliad@wizery.com>
	<1291116244.3624.10.camel@jlt3.sipsolutions.net>
Date: Tue, 30 Nov 2010 17:34:19 +0200
Message-ID: <AANLkTinrF_ZGeuLBJMr4xBXM4kHQ8u3LV400Q2mYELAy@mail.gmail.com>
Subject: Re: [PATCH] nl80211: add NL80211_ATTR_PS_TIMEOUT attribute
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 30, 2010 at 1:24 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2010-11-30 at 12:04 +0200, Eliad Peller wrote:
>> with this attribute we can control the timeout in dynamic ps
>> (similar to "iwconfig wlan0 power timeout" command).
>
> I don't really like this -- what's the point? What user is going to have
> a good idea of how to set this? We are currently setting this depending
> on the QoS requirements in mac80211, I believe, which seems smarter.
>

we looked for a way to customize the dynamic ps.
I missed the pm-qos stuff.
thanks for pointing out!

Eliad.
