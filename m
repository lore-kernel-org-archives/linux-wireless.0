Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:42039 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751858Ab0JTLkz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Oct 2010 07:40:55 -0400
Message-ID: <4CBEDF8A.8080508@gmx.net>
Date: Wed, 20 Oct 2010 14:24:42 +0200
From: George <george.news@gmx.net>
MIME-Version: 1.0
To: Grazvydas Ignotas <notasas@gmail.com>
CC: Luciano Coelho <luciano.coelho@nokia.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Bob Copeland <me@bobcopeland.com>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Compat-wireless N900
References: <4CB6BE57.8010401@gmx.net>	<1287071844.11341.5.camel@gnutoo-laptop>	<AANLkTikosEtFnWqRVzMBKtNsB=aqOpqQFKDOZS3+pXTE@mail.gmail.com>	<4CB74759.3030807@gmx.net>	<AANLkTi=1Ar-gzRaskHGDLmkaDnr=9+oZnA=qBLCYcUAi@mail.gmail.com>	<4CB7F7C7.7030804@gmx.net>	<AANLkTi=u+mT2Xd0=0vt4uaf9hSnnkPKY+wN6DjAxME3m@mail.gmail.com>	<4CBABB84.1090100@gmx.net>	<4CBC7725.7050202@gmx.net>	<AANLkTincCSBfwa_Y-cy_42HfU5kP1puCbi2-dBwGkkHu@mail.gmail.com>	<4CBC9A51.8030309@gmx.net>	<1287427291.8043.2.camel@powerslave>	<1287428554.8043.6.camel@powerslave>	<4CBD52DE.9090804@gmx.net>	<AANLkTi=dGSVBrdDXwJgmOjEGX+i+=P_KibiJd+NNMGfy@mail.gmail.com>	<4CBDB654.6060702@gmx.net>	<AANLkTimyCv6U+Yjf7q0OFEYF3PHr5PfACSpbXbTi_PZe@mail.gmail.com>	<4CBDBEDB.3070407@gmx.net>	<AANLkTik3ZdZov4OTn0NnnPe_ZUaRh_w0db4bwLYVGCRR@mail.gmail.com>	<4CBE9C4F.7050806@gmx.net> <AANLkTi=iSnEM4L9PxWUigw6_HSCLjGC=L38PgwuoML_8@mail.gmail.com>
In-Reply-To: <AANLkTi=iSnEM4L9PxWUigw6_HSCLjGC=L38PgwuoML_8@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20/10/2010 10:44, Grazvydas Ignotas wrote:
> On Wed, Oct 20, 2010 at 10:37 AM, George<george.news@gmx.net>  wrote:
>> On 19/10/2010 17:18, Grazvydas Ignotas wrote:
>>>>
>>>> I have also set the debug ALL mode to see if I get something that can
>>>> help
>>>> you out on finding the problem.
>>>>
>>>> When uploading only wl1251 nothing appears in dmesg. But when uploading
>>>> module spi, I got the following info: http://pastebin.com/ysdTSDnB
>>>
>>> You need both wl1251 and spi. This is normal output, you should get
>>> wlan0 interface at this point.
>>> --
>>
>> Yes, that is what I was expecting from the begining but although phy0 should
>> appear in /sys/class/ieee80211, this directory is empty :(
>
> Hm, maybe try enabling CONFIG_MAC80211_DEBUG* stuff in config.mk in
> compat_wireless.
> --

I have done that and no extra messages appear besides the former ones :(

Any other idea :(

I have look at compat-2.6.28.c and in the comments it says that is for 
kernel 2.6.28. However it is not compiled as in the #ifdef it is said to 
be < 2.6.28. Is it right? I guess yes, but just for curiosity.

No other idea :(


