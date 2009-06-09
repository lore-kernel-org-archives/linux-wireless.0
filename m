Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f214.google.com ([209.85.217.214]:51544 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693AbZFIV5I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2009 17:57:08 -0400
Received: by gxk10 with SMTP id 10so427496gxk.13
        for <linux-wireless@vger.kernel.org>; Tue, 09 Jun 2009 14:57:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200906092331.01072.tobias.doerffel@gmail.com>
References: <20090607150755.GA19635@hash.localnet>
	 <1244561607-6304-1-git-send-email-tobias.doerffel@gmail.com>
	 <b6c5339f0906091126k573b8725hf623367abcdcdf1f@mail.gmail.com>
	 <200906092331.01072.tobias.doerffel@gmail.com>
Date: Tue, 9 Jun 2009 17:57:09 -0400
Message-ID: <b6c5339f0906091457x73f33185s70d339afcd82bd0f@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH] ath5k: added cfg80211 based rfkill support
From: Bob Copeland <me@bobcopeland.com>
To: Tobias Doerffel <tobias.doerffel@gmail.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 9, 2009 at 5:31 PM, Tobias
Doerffel<tobias.doerffel@gmail.com> wrote:
> Hi,
>
> Am Dienstag, 9. Juni 2009 20:26:12 schrieb Bob Copeland:
>> > +       /* enable RFKILL when stopping HW so Wifi LED is turned off */
>> > +       ath5k_rfkill_enable(sc);
>>
>> Odd, but ok :)
> Why odd? As a user if I disable Wifi (i.e. enable rfkill, be it via software
> or rfkill switch), I do not want the LED to be active anymore. It also might
> have minimal influence on power consumption ;-)

No, I agree it is fine as-is, the oddness is just naming confusion (stop calls
rfkill_enable, sort of a double negative).  But I don't have anything better.

-- 
Bob Copeland %% www.bobcopeland.com
