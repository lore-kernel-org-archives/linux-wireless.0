Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:55002 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933711Ab0EZRqZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 13:46:25 -0400
Received: by mail-px0-f174.google.com with SMTP id 18so2635034pxi.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 May 2010 10:46:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4825B8A2C4E264489E57869F0DCFB22343E33E611F@hasmsx502.ger.corp.intel.com>
References: <1274856569-13436-1-git-send-email-emmanuel.grumbach@intel.com>
	<AANLkTikzEywcDi9zyJknMWkKymCVYnWQa2YXbbSDVx5o@mail.gmail.com>
	<4825B8A2C4E264489E57869F0DCFB22343E33E611F@hasmsx502.ger.corp.intel.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 26 May 2010 10:46:05 -0700
Message-ID: <AANLkTinG2zWHE8l-ZPBnyrFq5gs4nZX59zhF3AVh7h_4@mail.gmail.com>
Subject: Re: [RFC] wireless-regdb: Add A band in IL
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Michael Green <Michael.Green@atheros.com>,
	David Quan <David.Quan@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 26, 2010 at 10:32 AM, Grumbach, Emmanuel
<emmanuel.grumbach@intel.com> wrote:
>>>  country IL:
>>>        (2402 - 2482 @ 40), (N/A, 20)
>>> +       (5150 - 5250 @ 40). (N/A, 200 mW), NO-OUTDOOR
>>> +       (5250 - 5350 @ 40). (N/A, 200 mW), NO-OUTDOOR, DFS
>>
>>I believe the one standing issue here is you are enabling HT40 on 5
>>GHz, how about enabling 2.4 GHz first, and then through a separate
>>patch and time/review we review the HT40 stuff, unless you are in no
>>rush to get 2.4 GHz enabled.
>>
>
> I am not following... HT40 on 2.4 GHz is already enabled...
> What should I enable in 2.4 GHz ?

Sorry I meant 5 GHz.

  Luis
