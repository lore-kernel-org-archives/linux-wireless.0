Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38384 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755359Ab2ENJXQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2012 05:23:16 -0400
Received: by bkcji2 with SMTP id ji2so3586381bkc.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 May 2012 02:23:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK80WHYcaYPODP5iBL5y4yODAtm-cKMnJgtJyTPQxwUTg1Ztdg@mail.gmail.com>
References: <1336658913-11396-1-git-send-email-victorg@ti.com>
 <CA+XVXfcw+9vJ3pixC79DyQA25JmrpgC-m+PPohSdyUmLMe9Zig@mail.gmail.com> <CAK80WHYcaYPODP5iBL5y4yODAtm-cKMnJgtJyTPQxwUTg1Ztdg@mail.gmail.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Mon, 14 May 2012 12:15:22 +0300
Message-ID: <CA+XVXffRt3ujcuZvsWJfzzHepSGw7x8T9eCfhTa20Sj=4YucXQ@mail.gmail.com> (sfid-20120514_112319_770637_DA75DF9E)
Subject: Re: [PATCH v2] wl12xx: fix fm_coex parameters configuration
To: "Goldenshtein, Victor" <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, coelho@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 14, 2012 at 12:02 PM, Goldenshtein, Victor <victorg@ti.com> wrote:
> On Sat, May 12, 2012 at 10:17 PM, Arik Nemtsov <arik@wizery.com> wrote:
>>
>> On Thu, May 10, 2012 at 5:08 PM, Victor Goldenshtein <victorg@ti.com>
>> wrote:
>> > Wrong fm_coex parameters were set during wl12xx
>> > init phase, fix it.
>> >
>> > Signed-off-by: Ziv Riesel <zivriesel@ti.com>
>> > Signed-off-by: Victor Goldenshtein <victorg@ti.com>
>> > ---
>> >
>> > v2: changed the subject wlcore -> wl12xx
>>
>> Are you sure this is not relevant for 18xx? Are the parameters there
>> correct?
>>
>
> You're right, I will send a patch also for the 18xx. But I"m not sure
> which branch should I use ? To send also to Linux-Wireless ?
> Is the remotes/origin/18xx_upstream branch is good for upstream ?

Better send it rebased on the internal branch. I'll send it to linux
wireless later (together with other pending patches).

Arik
