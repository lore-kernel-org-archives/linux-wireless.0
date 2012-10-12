Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1238 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933185Ab2JLNHI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2012 09:07:08 -0400
Message-ID: <507815EE.5010508@broadcom.com> (sfid-20121012_150713_695740_6DD983D3)
Date: Fri, 12 Oct 2012 15:06:54 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Kalle Valo" <kvalo@qca.qualcomm.com>
cc: "John W. Linville" <linville@tuxdriver.com>,
	"Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Jouni Malinen" <j@w1.fi>,
	"Stanislav Yakovlev" <stas.yakovlev@gmail.com>,
	"Dan Williams" <dcbw@redhat.com>, "Bing Zhao" <bzhao@marvell.com>,
	"Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 1/3] wireless: drivers: make use of
 WLAN_EID_VENDOR_SPECIFIC
References: <1350037696-23747-1-git-send-email-arend@broadcom.com>
 <1350037696-23747-2-git-send-email-arend@broadcom.com>
 <5077F4F3.8030409@qca.qualcomm.com>
In-Reply-To: <5077F4F3.8030409@qca.qualcomm.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/12/2012 12:46 PM, Kalle Valo wrote:
> On 10/12/2012 01:28 PM, Arend van Spriel wrote:
>> The include file linux/ieee80211.h contains three definitions for
>> the same thing in enum ieee80211_eid due to historic changes:
>>
>> /* Information Element IDs */
>> enum ieee80211_eid {
>>      :
>>      WLAN_EID_WPA = 221,
>>      WLAN_EID_GENERIC = 221,
>>      WLAN_EID_VENDOR_SPECIFIC = 221,
>>      :
>> };
>>
>> The standard refers to this as "vendor specific" element so the
>> other two definitions are better not used. This patch changes the
>> wireless drivers to use one definition, ie. WLAN_EID_VENDOR_SPECIFIC.
>
> Why not remove _WPA and _GENERIC from ieee80211.h at the same time so
> that nobody else won't use them in the future?

Actually doing that in patch #3/3.

Regards,
Arend


