Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:62016 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756192AbZJ0Q4l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2009 12:56:41 -0400
Received: by iwn8 with SMTP id 8so268723iwn.33
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2009 09:56:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20091026213222.GA3956@tux>
References: <1256575447-4591-1-git-send-email-lrodriguez@atheros.com>
	<87d449hp73.fsf@purkki.valot.fi> <20091026204447.GA5713@tux>
	<878wexhn6m.fsf@purkki.valot.fi> <20091026213222.GA3956@tux>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 27 Oct 2009 09:56:26 -0700
Message-ID: <43e72e890910270956q507c7186r33f4ae85bd9c75c6@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] ath9k_hw: distinguish single-chip solutions on
	initial probe print
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 26, 2009 at 2:32 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Mon, Oct 26, 2009 at 02:15:13PM -0700, Kalle Valo wrote:
>> "Luis R. Rodriguez" <lrodriguez@Atheros.com> writes:
>>
>> >> I think you should provide the size of hw_name to this function and
>> >> use snprintf() to avoid writing out of bounds.
>> >
>> > I was going to do this but since I know the users of it and control
>> > it seemed to not matter. I'll respin with this added, better to be careful.
>>
>> Yeah, you never know if someone (for example a crazy Finn just after a
>> refreshing sauna) comes along, changes the function a bit "to clean it
>> up" and creates a subtle bug ;)
>
> Ah yes, forgot about the crazy sauna fins, must fix now for sure.

I have a couple of other fixes and since I no longer need to debug
ath9k_hw_reset() I'm going to drop the last patch in this series. I'll
resend this series then with the new patches.

  Luis
