Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47765 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580Ab0G1VOE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jul 2010 17:14:04 -0400
Received: by yxg6 with SMTP id 6so1125347yxg.19
        for <linux-wireless@vger.kernel.org>; Wed, 28 Jul 2010 14:14:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1280351044.3732.0.camel@jlt3.sipsolutions.net>
References: <1280334711-6141-1-git-send-email-linville@tuxdriver.com>
	<AANLkTim_Yr0Hx58GHYPfiPxRBWjspuFUd64epUHn_4La@mail.gmail.com>
	<1280351044.3732.0.camel@jlt3.sipsolutions.net>
Date: Wed, 28 Jul 2010 17:14:03 -0400
Message-ID: <AANLkTik-0nOnKxnUOr1DFA_1WbTDNoOQYP3qn_vMesCF@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH] ath5k: add led_disable module option
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 28, 2010 at 5:04 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2010-07-28 at 14:01 -0700, Luis R. Rodriguez wrote:
>> On Wed, Jul 28, 2010 at 9:31 AM, John W. Linville
>> <linville@tuxdriver.com> wrote:
>> > Not everyone agrees about LED behaviour...give them an escape hatch that
>> > will at least stop the lights from annoying them.
>> >
>> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
>>
>> I wonder if we can just do this on cfg80211 through a debugfs knob,
>> which would take care of all device drivers?
>
> We have proper API for this in sysfs if anybody bothered to hook this up
> through the LED class/trigger system

Yes, they are hooked up through the triggers, so you can disable
them via sysfs (which I have told several people, but complaints still
roll in...)

I don't have any devices with LEDs so either way I don't care too much.

-- 
Bob Copeland %% www.bobcopeland.com
