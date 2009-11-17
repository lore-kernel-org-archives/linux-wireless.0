Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:53660 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027AbZKQVfj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 16:35:39 -0500
Received: by iwn8 with SMTP id 8so377310iwn.33
        for <linux-wireless@vger.kernel.org>; Tue, 17 Nov 2009 13:35:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <b0c954732ea30effda967bd97ef30597@127.0.0.1>
References: <b0c954732ea30effda967bd97ef30597@127.0.0.1>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 17 Nov 2009 13:35:24 -0800
Message-ID: <43e72e890911171335n3193b63foa6f473ceb659f3ab@mail.gmail.com>
Subject: Re: [ath5k-devel] "iwlist scan" shows same ap twice
To: Florian Engelhardt <flo@dotbox.org>
Cc: ath5k-devel@lists.ath5k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 17, 2009 at 11:29 AM, Florian Engelhardt <flo@dotbox.org> wrote:
> Hello list,
>
> i recently have a problem with my ath5k wireless card in my Acer Aspire One
> Netbook. Executing iwlist scan shows some Wifi`s twice, but with different
> address and signal quality, which leads to me not being able to connect to
> this wlan.
> I attached an example output of iwlist scan.
> The WLAN "MA-WLAN" exists twice in the list, none of the Addresses is
> correct. I had the same problem with my WLAN (FOOBAR) until i moved it from
> channel 6 to channel 1.
>
> Can you please help me, what is going on here?
>
> This bug is realy annoying to me, couse every few days i have to change the
> wlan channel for it to work. Unloading an reloading the ath5k module does
> not help.
>
> Kind regards
>
> Florian
>
> PS: Please CC me, couse i am not on the list

That's wild. What kernel are you using? Have you tried:

http://wireless.kernel.org/en/users/Download/stable

or

http://wireless.kernel.org/en/users/Download

Can you provide the output of 'iw list', your dmesg, and your 'iw dev
wlan0 scan'.

  Luis
