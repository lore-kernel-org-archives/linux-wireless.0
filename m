Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:37495 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbYI3AFm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2008 20:05:42 -0400
Received: by gxk9 with SMTP id 9so11265326gxk.13
        for <linux-wireless@vger.kernel.org>; Mon, 29 Sep 2008 17:05:40 -0700 (PDT)
Message-ID: <43e72e890809291705k74093658y4843a1a7afc91f69@mail.gmail.com> (sfid-20080930_020546_236504_E5BFF27C)
Date: Mon, 29 Sep 2008 17:05:40 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Marcel Holtmann" <holtmann@linux.intel.com>
Subject: Re: Getting country alpha2 on network manager and using it for crda
Cc: "Dan Williams" <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni.Malinen@atheros.com
In-Reply-To: <1222732437.1825.31.camel@violet.holtmann.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <43e72e890809260024ob134358me80ae1c169e4da8e@mail.gmail.com>
	 <1222440218.19895.19.camel@localhost.localdomain>
	 <1222584975.9600.2.camel@californication>
	 <20080929183350.GC6203@tesla>
	 <1222720776.27930.35.camel@localhost.localdomain>
	 <43e72e890809291354u563b6c68i3a137cc129e65f86@mail.gmail.com>
	 <1222732437.1825.31.camel@violet.holtmann.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 29, 2008 at 4:53 PM, Marcel Holtmann
<holtmann@linux.intel.com> wrote:
> Hi Luis,
>
>> > I hesitate to try and specify an LSB-standard file anywhere for this,
>> > not sure we need that.  NM might want to store this value
>> > per-connection, or might want to store the value system-wide, or
>> > whatever.  I don't really see the value in standardizing the location of
>> > alpha2 config.
>>
>> The only reason why I was thinking of having a standard place for it
>> is that there may be more than one device which can help update the
>> country based on data it has (GPS, user, etc) and the fact that if we
>> are going to set this somewhere perhaps some other things can make use
>> of this as well?
>
> don't go that way. It will cause to many problems. We can add an option
> to the wpa_supplicant file if you really wanna store it (for the command
> line guys).

Stuffing it into wpa_supplicant.conf is fine. You're the one who
suggested a location manager :)

> Leave the rest to NetworkManager.

Alright.

  Luis
