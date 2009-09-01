Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f204.google.com ([209.85.223.204]:64461 "EHLO
	mail-iw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbZIATUB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 15:20:01 -0400
Received: by iwn42 with SMTP id 42so114992iwn.33
        for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2009 12:20:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1251832064.24846.2.camel@johannes.local>
References: <1251820465-11104-1-git-send-email-lrodriguez@atheros.com>
	<20090901163300.GA29047@jm.kir.nu> <20090901171848.GF8261@mosca>
	<69e28c910909011028i25fba508t9e68fb24168193eb@mail.gmail.com>
	<20090901173822.GG8261@mosca> <69e28c910909011047p2ecb7f9fg84b4089a70d1be5c@mail.gmail.com>
	<20090901180147.GA4272@mosca> <1251832064.24846.2.camel@johannes.local>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 1 Sep 2009 12:19:43 -0700
Message-ID: <43e72e890909011219l76a594a8u9471114a120fe67c@mail.gmail.com>
Subject: Re: [PATCH v2 6/7] wireless: update mac80211 kconfig entry
To: Johannes Berg <johannes@sipsolutions.net>
Cc: =?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 1, 2009 at 12:07 PM, Johannes Berg<johannes@sipsolutions.net> wrote:
> On Tue, 2009-09-01 at 11:01 -0700, Luis R. Rodriguez wrote:
>
>> Software MAC sounds reasonable to me. Anyone else?
>
> Except we're not actually talking about the MAC at all. The MAC is still
> in the hardware.

How how about just:

"mac80211 - IEEE 802.11 frame processing"

Then as for referring to these type of devices I am not aware of other
vocabulary for them other than SoftMAC or its derivative names.

  Luis
