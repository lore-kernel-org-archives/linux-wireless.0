Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1957 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759094Ab2JKRXf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Oct 2012 13:23:35 -0400
Message-ID: <5077008D.7030203@broadcom.com> (sfid-20121011_192339_707529_01A98BE3)
Date: Thu, 11 Oct 2012 19:23:25 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] wireless: cfg80211: add peer-to-peer related
 definitions
References: <1349965104-14475-1-git-send-email-arend@broadcom.com>
 <1349973674.13097.11.camel@jlt4.sipsolutions.net>
In-Reply-To: <1349973674.13097.11.camel@jlt4.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/11/2012 06:41 PM, Johannes Berg wrote:
> On Thu, 2012-10-11 at 16:18 +0200, Arend van Spriel wrote:
>> The Peer-to-Peer IE is vendor-specific IE identified by WiFi Alliance
>> OUI and specific P2P OUI type. The payload of this IE consists of
>> so-called P2P attributes. This patch adds definitions for processing
>> these attributes.
>
> Looks ok ... but why would a driver need to parse P2P stuff? For NoA for
> example maybe?

I did not yet go through a lot of the P2P code that is on my plate to 
port upstream, but one item that is extracted in the part I already did 
is the P2P listen channel. I just wanted to do this RFC before sending 
out the brcmfmac code patches that actually is using it. This change 
will be part of that patch series.

Gr. AvS

