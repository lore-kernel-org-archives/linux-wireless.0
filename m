Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from toronto053.server4you.de ([62.75.220.53]:52364 "EHLO
	toronto053.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbZDGTGn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2009 15:06:43 -0400
Message-ID: <49DBA457.7060307@monom.org> (sfid-20090407_210648_244322_554EFD0F)
Date: Tue, 07 Apr 2009 21:07:03 +0200
From: Daniel Wagner <wagi@monom.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: No local loopback for mac80211_hwsim test setup
References: <20090403123822.GA26100@toronto053.server4you.de>	 (sfid-20090403_150647_912363_CB6A5CE6) <1238787032.11352.1.camel@johannes.local>
In-Reply-To: <1238787032.11352.1.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Fri, 2009-04-03 at 14:38 +0200, Daniel Wagner wrote:
> 
>> So my question is this possible what I'd like to do? If so, what's the
>> trick to get it working?
> 
> It's not possible locally, unfortunately, afaik.

Ok, I found workaround for my problem. I'm using a VM with a small
linux distro inside. The networking interface is bridge to the wlan
interface. With this setup I can have some services running and have
real traffic over the 'link'. Not really lightweight, but well, I
guess hardware vendors like this approach.

thanks,
daniel
