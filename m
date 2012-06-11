Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:54212 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000Ab2FKVo4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 17:44:56 -0400
Message-ID: <4FD666D0.5020306@hauke-m.de> (sfid-20120611_234459_491593_265E7E05)
Date: Mon, 11 Jun 2012 23:44:48 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: linville@tuxdriver.com, brudley@broadcom.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 14/18] brcmsmac: extend xmtfifo_sz array
References: <1338937641-8519-1-git-send-email-hauke@hauke-m.de> <1338937641-8519-15-git-send-email-hauke@hauke-m.de> <4FCF2FD4.6010103@broadcom.com> <4FD0AD96.1050500@hauke-m.de> <4FD0FF3D.2060805@broadcom.com> <4FD49CC1.6030704@hauke-m.de> <4FD5A54C.9060403@broadcom.com>
In-Reply-To: <4FD5A54C.9060403@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/11/2012 09:59 AM, Arend van Spriel wrote:
> On 06/10/2012 03:10 PM, Hauke Mehrtens wrote:
>> On 06/07/2012 09:21 PM, Arend van Spriel wrote:
>>> I dived into this and basically there is no correlation to the phy type.
>>> There are chips with same 80211 core rev and different phy type as there
>>> are chips with different 80211 core rev and the same phy type.
>>>
>>> Gr. AvS
>>
>> Hi Arend,
>>
>> Ok, then I will leave it based on the core rev like it is now. Are the
>> values I added there for core rev 17 and 28 correct? They are just
>> copied from the other phy-n device which has the same values set after
>> powering up and before they are explicitly set. The core rev 17 device
>> is working for me, but the core rev 28 is not, but I do not know why. I
>> was unable to find these values in b43 or the spec b43 is based on.
>>
>> Hauke
>>
> 
> Dug up the values and for corerev 17 they are fine, but corerev 28 has
> different values:
> 
> { 9, 58, 22, 14, 14, 5 },       /* corerev 28 */
> 
> Gr. AvS
> 
Thanks for the values, I will change them.

Hauke
