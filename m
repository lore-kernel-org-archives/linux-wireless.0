Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.178]:53153 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbYH1Ljz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 07:39:55 -0400
Received: by ik-out-1112.google.com with SMTP id c28so170742ika.5
        for <linux-wireless@vger.kernel.org>; Thu, 28 Aug 2008 04:39:53 -0700 (PDT)
Message-ID: <1ba2fa240808280439m3524d17cm63deebdfc0d5b9dd@mail.gmail.com> (sfid-20080828_133957_512696_9C9F5427)
Date: Thu, 28 Aug 2008 14:39:53 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: iwl5000 oopses (was: iwl5000 oopses with Linus's tree)
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1219919760.8434.5.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1217937364.3603.37.camel@johannes.berg>
	 <1217938927.3603.40.camel@johannes.berg>
	 <1ba2fa240808050820j1aa0ae7cj11f2758caa5ba4df@mail.gmail.com>
	 <1219919760.8434.5.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 28, 2008 at 1:36 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2008-08-05 at 18:20 +0300, Tomas Winkler wrote:
>> On Tue, Aug 5, 2008 at 3:22 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> >
>> >> This is kernel 2.6.27-rc1-00504-g2b12a4c-dirty
>
>> > [  126.826663] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27kds
>> > [  126.826947] iwlagn: Copyright(c) 2003-2008 Intel Corporation
>> > [  126.828369] iwlagn: Detected Intel Wireless WiFi Link 5350AGN REV=0x24
>> > [  126.848680] iwlagn: Tunable channels: 13 802.11bg, 24 802.11a channels
>> > [  127.014564] firmware: requesting iwlwifi-5000-1.ucode
>> > [  127.170640] iwlagn: Error wrong command queue 43 command id 0x6B
>> > [  127.170832] ------------[ cut here ]------------
>> > [  127.170884] kernel BUG at drivers/net/wireless/iwlwifi/iwl-tx.c:1163!
>> > [  127.170941] Oops: Exception in kernel mode, sig: 5 [#1]
>
> This is still happening with -rc4.

I know, at least one regression.
Tomas
