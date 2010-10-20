Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59922 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab0JTIoy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Oct 2010 04:44:54 -0400
Received: by qwa26 with SMTP id 26so2103860qwa.19
        for <linux-wireless@vger.kernel.org>; Wed, 20 Oct 2010 01:44:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CBE9C4F.7050806@gmx.net>
References: <4CB6BE57.8010401@gmx.net>
	<1287071844.11341.5.camel@gnutoo-laptop>
	<AANLkTikosEtFnWqRVzMBKtNsB=aqOpqQFKDOZS3+pXTE@mail.gmail.com>
	<4CB74759.3030807@gmx.net>
	<AANLkTi=1Ar-gzRaskHGDLmkaDnr=9+oZnA=qBLCYcUAi@mail.gmail.com>
	<4CB7F7C7.7030804@gmx.net>
	<AANLkTi=u+mT2Xd0=0vt4uaf9hSnnkPKY+wN6DjAxME3m@mail.gmail.com>
	<4CBABB84.1090100@gmx.net>
	<4CBC7725.7050202@gmx.net>
	<AANLkTincCSBfwa_Y-cy_42HfU5kP1puCbi2-dBwGkkHu@mail.gmail.com>
	<4CBC9A51.8030309@gmx.net>
	<1287427291.8043.2.camel@powerslave>
	<1287428554.8043.6.camel@powerslave>
	<4CBD52DE.9090804@gmx.net>
	<AANLkTi=dGSVBrdDXwJgmOjEGX+i+=P_KibiJd+NNMGfy@mail.gmail.com>
	<4CBDB654.6060702@gmx.net>
	<AANLkTimyCv6U+Yjf7q0OFEYF3PHr5PfACSpbXbTi_PZe@mail.gmail.com>
	<4CBDBEDB.3070407@gmx.net>
	<AANLkTik3ZdZov4OTn0NnnPe_ZUaRh_w0db4bwLYVGCRR@mail.gmail.com>
	<4CBE9C4F.7050806@gmx.net>
Date: Wed, 20 Oct 2010 11:44:52 +0300
Message-ID: <AANLkTi=iSnEM4L9PxWUigw6_HSCLjGC=L38PgwuoML_8@mail.gmail.com>
Subject: Re: Compat-wireless N900
From: Grazvydas Ignotas <notasas@gmail.com>
To: George <george.news@gmx.net>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Bob Copeland <me@bobcopeland.com>,
	"Denis 'GNUtoo' Carikli" <GNUtoo@no-log.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 20, 2010 at 10:37 AM, George <george.news@gmx.net> wrote:
> On 19/10/2010 17:18, Grazvydas Ignotas wrote:
>>>
>>> I have also set the debug ALL mode to see if I get something that can
>>> help
>>> you out on finding the problem.
>>>
>>> When uploading only wl1251 nothing appears in dmesg. But when uploading
>>> module spi, I got the following info: http://pastebin.com/ysdTSDnB
>>
>> You need both wl1251 and spi. This is normal output, you should get
>> wlan0 interface at this point.
>> --
>
> Yes, that is what I was expecting from the begining but although phy0 should
> appear in /sys/class/ieee80211, this directory is empty :(

Hm, maybe try enabling CONFIG_MAC80211_DEBUG* stuff in config.mk in
compat_wireless.
