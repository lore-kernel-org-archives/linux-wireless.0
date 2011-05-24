Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43136 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932872Ab1EXWyX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2011 18:54:23 -0400
Received: by iwn34 with SMTP id 34so5923164iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 May 2011 15:54:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201105241627.49201.helmut.schaa@googlemail.com>
References: <BANLkTi=-MDn9eAsRsoXtAetDOZehkMEhJw@mail.gmail.com> <201105241627.49201.helmut.schaa@googlemail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 24 May 2011 15:54:03 -0700
Message-ID: <BANLkTikcEsKYo=c=ZmzJRbmfgjmrFmx9bg@mail.gmail.com> (sfid-20110525_005427_076148_21084EE0)
Subject: Re: Initial automatic channel selection implementation
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	hostap@lists.shmoo.com, Matt Smith <Matt.Smith@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 24, 2011 at 7:27 AM, Helmut Schaa
<helmut.schaa@googlemail.com> wrote:
> Hi Luis,
>
> Am Dienstag, 24. Mai 2011 schrieb Luis R. Rodriguez:
>> II - Load check:
>>
>>   * In addition to the above take into consideration some metric for
>> load on the channel: frame count observed
>
> Sounds similar to the busy time information some drivers already report
> via "iw wlan0 survey dump", no? Counting frames sounds like a lot of
> overhead to me.

Yes, thanks this is a lot of work already done. Now we just need a
basic algorithm to parse this, quantify how ideal this channel is and
then spit out a desired optimal channel.

  Luis
