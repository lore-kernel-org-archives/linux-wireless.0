Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f47.google.com ([209.85.219.47]:39900 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030257AbaEaNPV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 May 2014 09:15:21 -0400
Received: by mail-oa0-f47.google.com with SMTP id i7so2999726oag.6
        for <linux-wireless@vger.kernel.org>; Sat, 31 May 2014 06:15:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201405301818.13260@pali>
References: <1398125395-5579-1-git-send-email-notasas@gmail.com>
	<201405092203.00729@pali>
	<201405101428.45185@pali>
	<201405301818.13260@pali>
Date: Sat, 31 May 2014 16:15:20 +0300
Message-ID: <CANOLnOPUrgcov5jaL-VaExk8db7P7O-RVBBm4BJq9rhBmEcjZw@mail.gmail.com> (sfid-20140531_151532_144475_AFF5BD33)
Subject: Re: [PATCH 0/4] wl1251 IBSS fixes
From: Grazvydas Ignotas <notasas@gmail.com>
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Pavel Machek <pavel@ucw.cz>,
	David Gnedt <david.gnedt@davizone.at>, freemangordon@abv.bg
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 30, 2014 at 7:18 PM, Pali Rohár <pali.rohar@gmail.com> wrote:
> On Saturday 10 May 2014 14:28:45 Pali Rohár wrote:
>> On Friday 09 May 2014 22:03:00 Pali Rohár wrote:
>> > On Friday 09 May 2014 02:21:21 Grazvydas Ignotas wrote:
>> > > On Tue, Apr 22, 2014 at 3:09 AM, Grazvydas Ignotas
>> >
>> > <notasas@gmail.com> wrote:
>> > > > IBSS mode is currently advertised by wl1251 driver but
>> > > > is totally broken. First there is a disconnect hack for
>> > > > monitor mode that was recently merged, it abuses
>> > > > mac80211 and causes corruption in IBSS mode, so I think
>> > > > should be reverted. Then there are several cases of
>> > > > station-only mac80211 functions called carelessly, what
>> > > > is also fixed.
>> > >
>> > > Ping.
>> > > This driver is orphan and hardware carrying it is
>> > > outdated, so acks / tested-bys are unlikely..
>> >
>> > Now I'm testing these patches on wireless-testing git tree
>> > from year 2010 compiled against patched maemo 2.6.28 kernel.
>> >
>> > Reason for using these historical wireless-testing version
>> > is that this version can be compiled against kernel which
>> > working with default Maemo system in Nokia N900.
>> >
>> > It looks like your patches fixed some kernel oops when
>> > iwconfig changing mode to ad-hoc.
>>
>> Looks like everything working fine except power save mode. In
>> dmesg I see only these message:
>>
>> wl1251: ERROR Power save entry failed, giving up
>>
>> If you are OK with fact that I tested your patches with older
>> kernel (not last upstream), you can add my Tested-by.
>
> Grazvydas: PING

Sure I'm ok, patches seem to be already queued with your Tested-bys:
https://git.kernel.org/cgit/linux/kernel/git/linville/wireless-next.git/log/?h=e5b02f649bb

-- 
Gražvydas
