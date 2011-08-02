Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33272 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab1HBGjh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2011 02:39:37 -0400
Received: by fxh19 with SMTP id 19so5302377fxh.19
        for <linux-wireless@vger.kernel.org>; Mon, 01 Aug 2011 23:39:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4825B8A2C4E264489E57869F0DCFB22344563F4ABE@hasmsx502.ger.corp.intel.com>
References: <1312228017-12061-1-git-send-email-wey-yi.w.guy@intel.com>
 <CALSq=BYkKhJN=GU0RUJ2viibsy5yG78x-D-td0zP+rqWCy=AiQ@mail.gmail.com> <4825B8A2C4E264489E57869F0DCFB22344563F4ABE@hasmsx502.ger.corp.intel.com>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Mon, 1 Aug 2011 23:39:16 -0700
Message-ID: <CALSq=BZ2CoF=+Zw-si5oc8No9MLTP1YoZCzfoT9TX1XEaLnq1A@mail.gmail.com> (sfid-20110802_083943_047984_4F00B613)
Subject: Re: [PATCH wireless-3.1] iwlagn: sysfs couldn't find the priv pointer
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ACK, you're right.

2011/8/1 Grumbach, Emmanuel <emmanuel.grumbach@intel.com>:
>>
>> On Mon, Aug 1, 2011 at 12:46 PM, Wey-Yi Guy <wey-yi.w.guy@intel.com> wrote:
>> > From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>> >
>> > This bug has been introduced by:
>> > d593411084a56124aa9d80aafa15db8463b2d8f7
>> > Author: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>> > Date:   Mon Jul 11 10:48:51 2011 +0300
>> >
>> >    iwlagn: simplify the bus architecture
>> >
>>
>> Believe this fix needs to go to 3.0-stable too.
>>
>
> The buggy patch hasn't made it to 3.0. The bug was introduced in 3.1
> ---------------------------------------------------------------------
> Intel Israel (74) Limited
>
> This e-mail and any attachments may contain confidential material for
> the sole use of the intended recipient(s). Any review or distribution
> by others is strictly prohibited. If you are not the intended
> recipient, please contact the sender and delete all copies.
>
