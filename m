Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4977 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903Ab3GaKJB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 06:09:01 -0400
Message-ID: <51F8E228.9080600@broadcom.com> (sfid-20130731_120905_182184_47A78D14)
Date: Wed, 31 Jul 2013 12:08:40 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Mathieu Devos" <mathieu.devos@ugent.be>
cc: linux-wireless@vger.kernel.org
Subject: Re: Skb and ieee80211 headers
References: <CAE_+Soy5=MfUUahaP3Ka2onp+jP9aupbhGu_QHco=CP7Y9sqhQ@mail.gmail.com>
In-Reply-To: <CAE_+Soy5=MfUUahaP3Ka2onp+jP9aupbhGu_QHco=CP7Y9sqhQ@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/31/2013 11:39 AM, Mathieu Devos wrote:
> Hi,
>
> I hope this is the right place to ask for a little bit of help as I'm
> currently beyond stuck on a challenge I'm trying to accomplish. I'm
> trying to write a "simple" LKM that properly uses a ieee80211 header
> to print information about the mac addresses (addr1->addr4) and later
> down the road try to send my own data.
>
> I only need to get L2 working, no need for TCP/IP, just a proper
> ieee80211 based on input from skb would be huge for me.
>
> So my issue: when placing the ieee80211 on my mac_header after I hook
> my skb from my wireless device (wlan0 on android - I9100)

Not sure what you goal is, but what wireless device is that? You may 
just get 802.3 packets from the device.

Gr. AvS

> I get a huge
> amount of zero's and random(?) numbers when trying to print the
> addresses. This leads me to the first conclusion that mac_header is
> placed wrong when using 80211. After that I saw a lot of people just
> using the skb->data pointer. Now this gives even weirder issues for me
> and actually totally crashes my kernel.



