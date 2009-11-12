Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:34538 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbZKLPtP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2009 10:49:15 -0500
Received: by iwn8 with SMTP id 8so1840890iwn.33
        for <linux-wireless@vger.kernel.org>; Thu, 12 Nov 2009 07:49:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20091112154440.GD19349@tux>
References: <f74418680911120331w1ea31a68y56440dc0fbd253bb@mail.gmail.com>
	<40101cc30911120618m5d9acd34pf6aa9ec89c6c40b8@mail.gmail.com>
	<20091112154440.GD19349@tux>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 12 Nov 2009 07:49:01 -0800
Message-ID: <43e72e890911120749n72360f0btfb058ab3a521eabb@mail.gmail.com>
Subject: Re: [ath9k-devel] Possible memory leak in ath9k monitor mode
	injection
To: Matteo Croce <technoboy85@gmail.com>
Cc: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 12, 2009 at 7:44 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Thu, Nov 12, 2009 at 06:18:46AM -0800, Matteo Croce wrote:
>> On Thu, Nov 12, 2009 at 12:31 PM, Lorenzo Bianconi
>> <lorenzo.bianconi83@gmail.com> wrote:
>> > Hi all
>> >
>> > I am playing with ath9k/mac80211 in monitor mode and I suspect there
>> > is a memory leak.
>> > The leak happens when injecting in monitor mode when the destination
>> > MAC address is unicast.
>> > In fact there is no leak sending broadcast packet.
>> > I wrote this minimal test case module which triggers the leak.
>>
>> I can reproduce it with ath5k but not with madwifi, so the leak could
>> be in mac80211
>
> Can you please resend the thread to linux-wireless for wider review, with
> the code snippet and all?

Sorry failed to notice you already had.

 Luis
