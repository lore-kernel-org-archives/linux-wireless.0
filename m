Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:46014 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754062Ab1LUS5R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 13:57:17 -0500
Message-ID: <4EF23A1F.60803@xenotime.net> (sfid-20111221_195745_869045_2B23DA2A)
Date: Wed, 21 Dec 2011 11:57:19 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
MIME-Version: 1.0
To: Samuel Ortiz <samuel@sortiz.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: linux-next: Tree for Dec 19 (nfc)
References: <20111219185556.f07c1f43e28cfd594aaa5fe0@canb.auug.org.au>	 <4EEFA21B.5010305@xenotime.net> <1324399181.5354.0.camel@sortiz-mobl>
In-Reply-To: <1324399181.5354.0.camel@sortiz-mobl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/20/2011 08:39 AM, Samuel Ortiz wrote:
> Hi Randy,
> 
> On Mon, 2011-12-19 at 12:44 -0800, Randy Dunlap wrote:
>> On 12/18/2011 11:55 PM, Stephen Rothwell wrote:
>>> Hi all,
>>>
>>> Changes since 20111216:
>>
>>
>> (not new today, just not reported earlier)
> John applied my fix for this one. It should be fixed now.

Hi Samuel,

Is this supposed to be fixed in linux-next?
It still fails today (linux-next 20111221).


data.c:(.text+0x3e0): multiple definition of `nfc_llcp_mac_is_down'
data.c:(.text+0x400): multiple definition of `nfc_llcp_mac_is_up'
ntf.c:(.text+0xb60): multiple definition of `nfc_llcp_mac_is_down'
ntf.c:(.text+0xb80): multiple definition of `nfc_llcp_mac_is_up'
rsp.c:(.text+0x750): multiple definition of `nfc_llcp_mac_is_down'
rsp.c:(.text+0x770): multiple definition of `nfc_llcp_mac_is_up'
netlink.c:(.text+0x14e0): multiple definition of `nfc_llcp_mac_is_down'
netlink.c:(.text+0x1500): multiple definition of `nfc_llcp_mac_is_up'
af_nfc.c:(.text+0xe0): multiple definition of `nfc_llcp_mac_is_down'
af_nfc.c:(.text+0x100): multiple definition of `nfc_llcp_mac_is_up'
rawsock.c:(.text+0x1000): multiple definition of `nfc_llcp_mac_is_down'
rawsock.c:(.text+0x1020): multiple definition of `nfc_llcp_mac_is_up'


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
