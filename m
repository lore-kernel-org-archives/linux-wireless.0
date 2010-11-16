Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39817 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170Ab0KPVpn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 16:45:43 -0500
Received: by iwn35 with SMTP id 35so1299398iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 16 Nov 2010 13:45:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1289943378.3673.11.camel@jlt3.sipsolutions.net>
References: <AANLkTikb+2PypN+nOGDYbuN1mRGjWCZRuTQ16HsRNo=p@mail.gmail.com>
	<AANLkTi=PZ8TH2PG7rKz9-nt3S4ZLzvMw_478QrYOpVkm@mail.gmail.com>
	<1289943378.3673.11.camel@jlt3.sipsolutions.net>
Date: Tue, 16 Nov 2010 22:45:41 +0100
Message-ID: <AANLkTikkcfsRWuXLAxtx5fSdj5fRkose6_A8+TnPF83H@mail.gmail.com>
Subject: Re: [iwlwifi] Rate Adaptation
From: "An (Jack) Chan" <jackachan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thank you very much, Johannes.

I have one more question. Do you know if iwl5000 supports both
Space-Time Block Coding (STBC) and Spatial Multiplexing (SM)? That
means I can change the rates in both STBC and SM schemes?

As I know in Ralink's RT2880, their configuration file provides an
interface for setting different MCS values. STBC is from 0 to 7, while
SM is from 8 to 15, and 33 is auto-rate.

Jack


On Tue, Nov 16, 2010 at 10:36 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2010-11-16 at 21:12 +0100, An (Jack) Chan wrote:
>
>> Does anyone know where I can find the implementation of rate
>> adaptation in iwl5000 driver?
>
> It's in iwl-agn-rs.c
>
> johannes
>
>
