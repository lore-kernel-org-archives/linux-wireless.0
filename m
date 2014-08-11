Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:57701 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbaHKW6g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2014 18:58:36 -0400
Received: by mail-qc0-f174.google.com with SMTP id l6so2189004qcy.19
        for <linux-wireless@vger.kernel.org>; Mon, 11 Aug 2014 15:58:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CBACCFA0AEB13A41977475BCF3E896FC4781147BD9@SC-VEXCH2.marvell.com>
References: <CALtMJEDfVr1UxExOsiGK4G54BHB54wLt8co_98yZpFzH7NY9VA@mail.gmail.com>
	<CBACCFA0AEB13A41977475BCF3E896FC4781147BD9@SC-VEXCH2.marvell.com>
Date: Tue, 12 Aug 2014 00:58:36 +0200
Message-ID: <CALtMJECey7bykvHp03-r1N=d774bOUyUagJqZAbZEeHwDPstew@mail.gmail.com> (sfid-20140812_005840_380335_5AAAE7AA)
Subject: Re: mwifiex: switching from adhoc to 5GHz managed fails
From: Andreas Fenkart <afenkart@gmail.com>
To: Avinash Patil <patila@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Avinash,

2014-08-08 14:51 GMT+02:00 Avinash Patil <patila@marvell.com>:
> Are you setting type back to managed after leaving ibss?
yes

> I quickly tried this in my setup and after setting type to managed before connection to 5GHz AP, association is successful.

15ba2236f3556fc01b9ca91394465152b5ea74b6 Merge
git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
9a3c4145af32125c5ee39c0272662b47307a8323 Linux 3.16-rc6

and latest commit in driver/net/wireless/mwifiex:
701a9e619347ac06d59481db14bbc4df99763270 mwifiex: initialize Tx/Rx
info of a packet correctly

Am I missing some patches?

> If I dont set type, I see error from iw itself "operation not supported".
I receive "ASSOC_RESP: failed:"

iw version : 3.13
