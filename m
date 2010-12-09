Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:33506 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354Ab0LIWmB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 17:42:01 -0500
Received: by qwa26 with SMTP id 26so3160173qwa.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Dec 2010 14:41:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101209170040.GA24840@hash.localnet>
References: <AANLkTimDF3kofO=kiuOsz+WrTGROdOL8-3eNvKd5NrD3@mail.gmail.com>
 <201012061714.15863.br1@einfach.org> <AANLkTi=+bZbsZXR2v1AUKLEEAWGLpq-uNJXQ13t-Bf+D@mail.gmail.com>
 <AANLkTimwprBJpnLM6_Qap1wSVboVJPQecAUgmzAnQhu-@mail.gmail.com>
 <AANLkTim5hESSHAMYNryUwak=D4tQetZJuDEK41Yq3A+L@mail.gmail.com>
 <20101209123841.GA31566@hash.localnet> <AANLkTinmsG9NhiiigOrFZQUS+pdDaHSvxpN7JnjdUXs=@mail.gmail.com>
 <20101209170040.GA24840@hash.localnet>
From: Jonathan Guerin <jonathan@guerin.id.au>
Date: Fri, 10 Dec 2010 08:41:37 +1000
Message-ID: <AANLkTinr2fE7EEorm+ZzziT5xmVZo8H1tcBZ7PoGgVR0@mail.gmail.com>
Subject: Re: ath5k: Weird Retransmission Behaviour
To: Bob Copeland <me@bobcopeland.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	Bruno Randolf <br1@einfach.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath5k-devel <ath5k-devel@lists.ath5k.org>, nbd@openwrt.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 10, 2010 at 3:00 AM, Bob Copeland <me@bobcopeland.com> wrote:
> On Fri, Dec 10, 2010 at 12:34:19AM +1000, Jonathan Guerin wrote:
>> > For what it's worth, I tested pid and minstrel a while ago with a
>> > modified mac80211_hwsim, and found minstrel to be quite a bit better
>> > at rate adaptation.  So while it may be worth testing out for this
>> > particular use case, minstrel is probably the way to go in general.
>>
>> So, while I say this with no idea how to do it, might it be worth
>> fixing Minstrel so that it adheres to mac80211's maximum retry values?
>
> Yeah, so that's what the linked patch I posted tries to do :)

Doh! I didn't read it properly - I assumed it was for PID... My bad.

Cheers,

Jonathan

>
> --
> Bob Copeland %% www.bobcopeland.com
>
>
