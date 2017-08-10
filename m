Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f181.google.com ([209.85.161.181]:36006 "EHLO
        mail-yw0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750868AbdHJHwZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Aug 2017 03:52:25 -0400
MIME-Version: 1.0
In-Reply-To: <8665E2433BC68541A24DFFCA87B70F5B36422C65@DFRE01.ent.ti.com>
References: <1502264840-10569-1-git-send-email-eyalr@ti.com>
 <8665E2433BC68541A24DFFCA87B70F5B36420E5A@DFRE01.ent.ti.com>
 <20170809172651.GA3934@atomide.com> <ngx9scofrw0qb2vkesion8v9.1502300336052@email.android.com>
 <20170809211620.GF3934@atomide.com> <8665E2433BC68541A24DFFCA87B70F5B36422C65@DFRE01.ent.ti.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 10 Aug 2017 17:52:04 +1000
Message-ID: <CAGRGNgW5Q3J1wL7Moc9vLJuRmOK3ZVr_gJfNqYPeU5BoeRuXtw@mail.gmail.com> (sfid-20170810_095238_898330_69212FBA)
Subject: Re: [v6] wlcore: add missing nvs file name info for wilink8
To: "Reizer, Eyal" <eyalr@ti.com>
Cc: Tony Lindgren <tony@atomide.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sebastian.reichel@collabora.co.uk"
        <sebastian.reichel@collabora.co.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Eyal,

On Thu, Aug 10, 2017 at 4:35 PM, Reizer, Eyal <eyalr@ti.com> wrote:
>> >
>> > Sorry for top posting (mobile...)
>> > I have verified with system design and the data sheet that every wilink 6/7
>> chip has a mac address in fuse so probably the board you have (pretty old,
>> right?) has this mac address in fuse. Maybe it was from very early batches?
>> Anyway I see no reason to change it.
>> > Anyway the calibrator can be used to store a different one into the nvs file
>> that will overide it.
>>
>> Well clearly at least this one does not have any valid hardware
>> mac address, the hardware mac address is broken with all zeroes.
>>
>
> Looks like it is not really all zeros but rather 00:00:00:00:00:01.
> I wonder if it is just a one board issue or not...

It's 00:00:00:00:00:01 because your code adds 1 to it.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
