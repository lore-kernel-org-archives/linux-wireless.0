Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:37686 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751130Ab2DEEWC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Apr 2012 00:22:02 -0400
Message-ID: <4F7D1DE4.5000000@posedge.com> (sfid-20120405_062229_121471_70163E14)
Date: Thu, 05 Apr 2012 09:51:56 +0530
From: Mahesh <maheshp@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Chakra Parvathaneni <chakra@posedge.com>
Subject: Re: 802.11ac support
References: <f17c700977012ada368da4f339b9c639@posedge.com>  <1329933458.4657.2.camel@jlt3.sipsolutions.net>  <1329937072.4657.4.camel@jlt3.sipsolutions.net>  <4F471F40.8060503@posedge.com>  <1330070145.3426.8.camel@jlt3.sipsolutions.net>  <4F4772AB.9000305@posedge.com>  <CAJ-VmomfVCc0oQMjfwsrheC+Z2k3+-czo4F9GeeO=upHiHnQxg@mail.gmail.com>  (sfid-20120225_202329_108179_7C3BAD32) <1330205424.3509.5.camel@jlt3.sipsolutions.net>  <eab3dfdc8ebc87ec08ca64db9f237d90@posedge.com>  (sfid-20120402_104501_564453_6BF9F70F) <1333454805.3574.14.camel@jlt3.sipsolutions.net>
In-Reply-To: <1333454805.3574.14.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/03/2012 05:36 PM, Johannes Berg wrote:
> On Mon, 2012-04-02 at 14:07 +0530, Mahesh wrote:
>
>> I had analysed mac80211 code to see what changes are required for 11ac
>> support. Attached word doc describes mac80211 modules in detail and last
>> section describing what changes we need for 11ac. This is a proposal.
>> Please review and let me know your opinion.
> You really shouldn't try to send word documents to the list, they won't
> arrive anyway. Also, it's bad form to send out documents that say
> "confidential" all over them ...
> Most people also probably don't care about your analysis of what
> mac80211 already does.
>
> In any case, here's my list of things I think will/may need to be done
> for 11ac in the stack:
>   * extend regulatory framework (cfg80211)
>   * advertise VHT capabilities (nl80211/cfg80211/mac80211&  each driver)
>   * advertise VHT in scan (mac80211)
>   * advertise VHT in assoc req (mac80211)
>   * advertise VHT in P2P probe responses (wpa_supplicant)
>   * advertise VHT in AP/GO mode beacons/probe responses
>     (wpa_supplicant/hostapd)
>   * handle per-station VHT capa (mac80211, wpa_s)
>   * extended CSA (mac80211)
>   * VHT transmit power envelope/extended power constraint (mac80211)
>   * quiet channels?
>   * HT/VHT basic rate handling?
>   * neighbor reports?
>   * beamforming action frame support? (mac80211)
>
> johannes
>
Thanks for listing the 11ac requirements. will work on those and post my 
updates.

~Mahesh
