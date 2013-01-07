Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from intranet.asianux.com ([58.214.24.6]:4018 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab3AGG5m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jan 2013 01:57:42 -0500
Message-ID: <50EA721C.8060806@asianux.com> (sfid-20130107_075747_499597_4D04D937)
Date: Mon, 07 Jan 2013 14:58:36 +0800
From: Chen Gang <gang.chen@asianux.com>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	stas.yakovlev@gmail.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [RFC PATCH] vsprintf: Add %p*D extension for 80211 SSIDs
References: <50E82D7D.4090107@asianux.com>  <1357396966.21156.4.camel@joe-AO722> <50EA37CE.1090901@asianux.com>  <1357528746.4940.31.camel@joe-AO722> <1357534195.21481.31.camel@joe-AO722>  <50EA6612.6010506@asianux.com> <1357540670.21481.38.camel@joe-AO722>
In-Reply-To: <1357540670.21481.38.camel@joe-AO722>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

于 2013年01月07日 14:37, Joe Perches 写道:
> You did fine except you unnecessarily quoted the entire original email.
> Remember to trim your replies please.  _lots_ of people read these
> mailing lists and unnecessary quoting wastes all of their times.
> 
  ok, thank you.

  I should notice, next time.  :-)

>> >   at least for me:
>> >     although it is good idea to add common, widely used features in public tools function.
> It's akin to most of the minor uuid/bluetooth mac, etc codes

  after see the comments for function pointer in lib/vsprintf.c
  sorry for I do not think it is suitable to add ssid in vsprintf
    all formate features in vsprintf are face to kernel wide, not for one sub system
      one exception is for mac and ip:
        they have already been well known in kernel wide
        every one knows about mac and ip.
    I feel, our ssid is not quite well known in kernel wide

  maybe current place (net/wireless/) is not quite suitable for print_ssid:
    for bluetooth, it is not belong to net/wireless.
    if necessary, I suggest to reconstruct it within net sub system wide, not in kernel wide.


  (it is also my fault for my original reply, it is not quite clear)


  Regards

-- 
Chen Gang

Asianux Corporation
