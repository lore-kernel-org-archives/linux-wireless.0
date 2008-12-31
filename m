Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aa002msb.fastweb.it ([85.18.95.81]:59059 "EHLO
	aa002msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157AbYLaOKY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Dec 2008 09:10:24 -0500
Received: from [192.168.1.101] (39.234.158.229) by aa002msb.fastweb.it (8.0.013.8)
        id 493752D305CB0B33 for linux-wireless@vger.kernel.org; Wed, 31 Dec 2008 15:10:23 +0100
Message-ID: <495B7D4E.80403@techemia.com> (sfid-20081231_151030_523026_84FA36A1)
Date: Wed, 31 Dec 2008 15:10:22 +0100
From: techmin <info@techemia.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: problem on gelic ps3 driver 2.25.2 kernel (used with psubuntu)
References: <4958C029.7000407@techemia.com>
In-Reply-To: <4958C029.7000407@techemia.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

techmin ha scritto:
> If i configure network with tool, the icon show 100% connection (and 
> it is not possible, maximum is 50% cause the distance to acces point), 
> wireless is protect (i use wep) but the led not blinck, simply is on. 
> But ping not work, and is not possible to navigate on the web.
> If i configure directly from /etc/network/interfaces (with all 
> network-manager disabled) same problem.
> If i use simple script to manually pass the iwconfig and ifconfig 
> command same proble.
> If i not use protection same problem.
>
> If i set manage mode:
> managed mode is not set, operation not permitted
>
> iwlist scan work.
> Note: in iwconfig not appear the channel and if i add manually the 
> channel with iwconfig wlan0 channel numder i have error: operation not 
> permitted.
>
> syslog don't have any entry
> only error is this:
> gelic_eurus_sync_cmd_worker: cmd issue failed
>
>
Compiled 2.6.27 kernel from git
wireless WORK
a this point i suppose is an issue of 2.6.25-2 kernel

