Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3167 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753912Ab2JPRHH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2012 13:07:07 -0400
Message-ID: <507D9429.7040105@broadcom.com> (sfid-20121016_190711_923049_A63FF8F9)
Date: Tue, 16 Oct 2012 19:06:49 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: linux-wireless@vger.kernel.org, "Jouni Malinen" <j@w1.fi>
Subject: Re: [RFC] wireless: cfg80211: add peer-to-peer related
 definitions
References: <1349965104-14475-1-git-send-email-arend@broadcom.com>
 <1349973674.13097.11.camel@jlt4.sipsolutions.net>
 <5077008D.7030203@broadcom.com>
 <1349976385.13097.13.camel@jlt4.sipsolutions.net>
 <50770A50.3010305@broadcom.com>
 <1349984058.13097.17.camel@jlt4.sipsolutions.net>
In-Reply-To: <1349984058.13097.17.camel@jlt4.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/11/2012 09:34 PM, Johannes Berg wrote:
> On Thu, 2012-10-11 at 20:05 +0200, Arend van Spriel wrote:
>
>>> Ah, fmac, that will be somewhat interesting. What userspace APIs are you
>>> proposing for that case?
>
>> Not sure if I understand the question. I am using wpa_supplicant with
>> wpa_cli for testing and given its p2p support I assumed there is already
>> a nl80211 api in place. I am still trying to get a good sense on it. The
>> P2P code to port does more parsing of P2P stuff and if you mean adding
>> userspace APIs to avoid just that I would definitely prefer that.
>
> Well the APIs that we have in place right now are really basically just
> a conduit and wpa_s does all the operations. I would expect fmac to have
> more offloads (and thus need the parsing), I'd actually be surprised if
> you could work with the existing APIs.

I mainly focussed on reworking brcmfmac to support multiple (virtual) 
interfaces and wireless devices without netdev. So far I only did the 
scanning part of p2p device discovery which is a regular 802.11 scan so 
no API change needed there. So no API change proposals yet. When I learn 
more I will discuss it on the wireless list.

Gr. AvS

