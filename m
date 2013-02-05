Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:33411 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755267Ab3BENr7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2013 08:47:59 -0500
Received: by mail-lb0-f176.google.com with SMTP id s4so231534lbc.7
        for <linux-wireless@vger.kernel.org>; Tue, 05 Feb 2013 05:47:58 -0800 (PST)
Message-ID: <51110D86.8030500@gmail.com> (sfid-20130205_144803_212385_7E7E3E6B)
Date: Tue, 05 Feb 2013 14:47:50 +0100
From: Pontus Fuchs <pontus.fuchs@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [RFC] cfg80211: configuration for WoWLAN over TCP
References: <1360062367-15970-1-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1360062367-15970-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-02-05 12:06, Johannes Berg wrote:
>
> Intel Wireless devices are able to make a TCP connection
> after suspending, sending some data and waking up when
> the connection receives wakeup data (or breaks). Add the
> WoWLAN configuration and feature advertising API for it.
>

What's protecting this feature from stomping on an existing connection 
when specifying the source port?

//Pontus
