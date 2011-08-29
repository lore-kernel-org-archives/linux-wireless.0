Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65022 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219Ab1H2SyT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 14:54:19 -0400
Received: by iabu26 with SMTP id u26so735322iab.19
        for <linux-wireless@vger.kernel.org>; Mon, 29 Aug 2011 11:54:18 -0700 (PDT)
Message-ID: <4E5BE058.4090302@lwfinger.net> (sfid-20110829_205422_351272_70F7F817)
Date: Mon, 29 Aug 2011 13:54:16 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: Looking for BCM43228
References: <CACna6rwU4RuYuiAFjXFDH-c+EFsKtKFmB1Sh8kXdb9EoUt4abg@mail.gmail.com> <CACna6rzkSgbf8sV2S1mg2OhxKstXeiqnmNmYFSMuAc563acBpg@mail.gmail.com>
In-Reply-To: <CACna6rzkSgbf8sV2S1mg2OhxKstXeiqnmNmYFSMuAc563acBpg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/29/2011 01:12 PM, Rafał Miłecki wrote:
> W dniu 29 sierpnia 2011 19:28 użytkownik Rafał Miłecki
> <zajec5@gmail.com>  napisał:
>> I'm looking for 14e4:4359 card which is BCM43228 chipset based.
>>
>> According to Ubuntu [0] it can be found in Dell's notebooks:
>> 1) Dell Latitude E5420m
>> 2) Dell Latitude E5520m
>> 3) Dell Latitude E6220
>>
>> Ubuntu user Marc Legris provided a prove this card is really used by
>> Dell. See any of his launchpad reports for lspci [1] [2] [3].
>>
>> I've search on ebay and polish similar site, no results so far. Ofc
>> I'm not interested in buying the whole laptop just for WiFi card. I'll
>> be contacting Dell in next days to see if they can offer me a card.
>
> I've chatted with Dell employee and have received list of parts they
> have for E5520m and E6220. Some of them are not wifi cards at all,
> some are Intel's one.
>
> Cards that may be interesting to look at: DW1530, DW1501.

The DW1501 is an 802.11b/g/n card. From what I saw about the BCM43228, it is an 
802.11a/b/g/n model.

The site http://tinyurl.com/3mh8kk9 says that the DW1530 has 5 GHz capability. 
It is probably what you want, but Ebay doesn't have any.

Larry
