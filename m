Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f170.google.com ([209.85.210.170]:40176 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab1HJKYB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 06:24:01 -0400
Received: by iye16 with SMTP id 16so927516iye.1
        for <linux-wireless@vger.kernel.org>; Wed, 10 Aug 2011 03:24:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1312967955.2407.452.camel@cumari>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
	<1312881233-9366-9-git-send-email-eliad@wizery.com>
	<1312967955.2407.452.camel@cumari>
Date: Wed, 10 Aug 2011 13:24:00 +0300
Message-ID: <CAB3XZEf-TyTfuF_p6WcZVn2T7_3A+K75GeYLAOOzHcx12qX7mA@mail.gmail.com> (sfid-20110810_122406_469599_9D35199D)
Subject: Re: [PATCH 08/40] wl12xx: wl12xx-fw-3 - update commands & events
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 10, 2011 at 12:19 PM, Luciano Coelho <coelho@ti.com> wrote:
> On Tue, 2011-08-09 at 12:13 +0300, Eliad Peller wrote:
>> +enum wl1271_cmd_lid_key_type {
>> +     UNICAST_LID_TYPE     = 0,
>> +     BROADCAST_LID_TYPE   = 1,
>> +     WEP_DEFAULT_LID_TYPE = 2
>> +};
>
> Doesn't LID_TYPE_UNICAST, LID_TYPE_BROADCAST and so on look better?
>
it does, but i didn't touch this struct (it wasn't in the context diff
expected, so it looks like it was deleted and re-added), and i should
avoid adding more stuff (changing all the existing uses of this enum)
to this already-too-big patch.

Eliad.
