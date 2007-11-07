Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:47341 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940AbXKGQoM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Nov 2007 11:44:12 -0500
Received: by nf-out-0910.google.com with SMTP id g13so2061462nfb
        for <linux-wireless@vger.kernel.org>; Wed, 07 Nov 2007 08:44:10 -0800 (PST)
Message-ID: <4731EB59.3020305@gmail.com> (sfid-20071107_164421_194029_D67E36C1)
Date: Wed, 07 Nov 2007 17:44:09 +0100
From: drago01 <drago01@gmail.com>
MIME-Version: 1.0
To: Claudio Matsuoka <claudio@mandriva.com>
CC: Stefano Brivio <stefano.brivio@polimi.it>,
	Michael Wu <flamingice.sourmilk.net@polimi.it>,
	Johannes Berg <johannes.sipsolutions.net@polimi.it>,
	Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
Subject: Re: mac80211 doesn't reassociate after failed ProbeResp
References: <20071107102158.61b4ca3d@morte> <200711070849.53931.claudio@mandriva.com>
In-Reply-To: <200711070849.53931.claudio@mandriva.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Claudio Matsuoka wrote:
> On Wednesday 07 November 2007 07:21:58 Stefano Brivio wrote:
>
>   
>> then, instead of trying to reassociate, mac80211 acts like this:
>> Nov  7 02:06:25 morte [123785.138041] wlan0: dropped data frame to not
>> associated station 00:14:c1:35:8d:eb Nov  7 02:06:25 morte [123785.138243]
>>     
>
> I confirm this problem with the b43, and also rtl8187 (which sometimes 
> reassociates spontaneously, sometimes not).
>
>   
I have also seen some reports where this happened with iwl3945/4965

