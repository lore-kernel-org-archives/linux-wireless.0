Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:62786 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066Ab1BYQH0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Feb 2011 11:07:26 -0500
Received: by pxi15 with SMTP id 15so275050pxi.19
        for <linux-wireless@vger.kernel.org>; Fri, 25 Feb 2011 08:07:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110225144718.63550601@realh.co.uk>
References: <20110224182022.57e32862@toddler>
	<20110224200203.GB17412@elie>
	<AANLkTiksoeKhMaFarSDVCbcDbZx6iWHkYzrg--1NcKKA@mail.gmail.com>
	<20110225144718.63550601@realh.co.uk>
Date: Fri, 25 Feb 2011 21:37:25 +0530
Message-ID: <AANLkTinu9NgnZZmieh2PU6e-iShOkapV9kcVe8YGtPHG@mail.gmail.com>
Subject: Re: [ath9k-devel] ath9k causes lockups since kernel 2.6.35
From: Mohammed Shafi <shafi.ath9k@gmail.com>
To: Tony Houghton <h@realh.co.uk>
Cc: Jonathan Nieder <jrnieder@gmail.com>, ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jmalinen@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Vivek Natarajan <vnatarajan@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 25, 2011 at 8:17 PM, Tony Houghton <h@realh.co.uk> wrote:
> On Fri, 25 Feb 2011 13:21:32 +0530
> Mohammed Shafi <shafi.ath9k@gmail.com> wrote:
>
>> > Tony Houghton wrote:
>> >
>> >> With 2.6.37 I can not use suspend on my Compaq/HP 311c (Intel Atom
>> >> N270/NVidia Ion LE). Originally the machine just kept locking up without
>> >> even blanking the display when I tried to suspend (using the GNOME menu
>> >> or by shutting the lid).
>
> [Snip]
>
> The above was from my original message before I worked out that the
> problem was in the wireless because disabling and reneabling wireless,
> killing the ath9k module etc, would often produce similar crashes, but
> suspend seems to do it more consistently.

Ok.

>
>> >> booting, but it's always a complete lock-up ie the keyboard is
>> >> completely responsive, including caps lock, the mouse won't move if the
>
> I meant *un*responsive of course!
>
>> >> I haven't tried looking in logs because the crashes are so severe I
>> >> don't think they'd be able to record anything useful.

Can you please get those messages with net console ?

>
> If I enable debugging is there a way to get it to sync to disc after
> every message? I think the developers are going to need at least that
> information to be able to track this down.

Yes sure, that could narrow down the issue.

>
>> is this issue still reproducible ?
>
> Yes :-(.

It would be highly helpful if this issue is reproducible in the latest
wireless testing or compat wireless. It will help us to fix it cleanly

>
>> Apart from this reporting I have not seen any other  issues for AR9285.
>
> Strange, isn't it. I can't be the only person trying to use a recent
> version of Linux on one of these netbooks, but I couldn't find any
> similar complaints on Google. Maybe mine has an obscure fault which is
> only triggered by a feature supported in the newer kernels.
>

also need to rule out its a platform independent issue.
