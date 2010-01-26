Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f189.google.com ([209.85.222.189]:34999 "EHLO
	mail-pz0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932132Ab0AZTGc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2010 14:06:32 -0500
Received: by pzk27 with SMTP id 27so922867pzk.33
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jan 2010 11:06:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87bpghnp4v.fsf@purkki.valot.fi>
References: <4B5CB7AB.7010105@bzz.no> <b6c5339f1001250951u548e6a16raf661464660ec577@mail.gmail.com>
	<69e28c911001251030p79f00ea1j23f95b5e2f8571a3@mail.gmail.com>
	<43e72e891001251120y568e480fje5cfc370c969c744@mail.gmail.com>
	<87bpghnp4v.fsf@purkki.valot.fi>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 26 Jan 2010 11:06:11 -0800
Message-ID: <43e72e891001261106w493225c2g6e9a5ff0ef9e41de@mail.gmail.com>
Subject: Re: Bug: 2.6.32 ath5k, unable to connect to AP on channel 13
To: Kalle Valo <kalle.valo@iki.fi>
Cc: =?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>,
	Bob Copeland <me@bobcopeland.com>,
	"John S. Skogtvedt" <jss@bzz.no>, linux-wireless@vger.kernel.org,
	Kel Modderman <kel@otaku42.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 26, 2010 at 2:20 AM, Kalle Valo <kalle.valo@iki.fi> wrote:
> "Luis R. Rodriguez" <lrodriguez@atheros.com> writes:
>
>>> However, does the DK regdomain really get set? Is CRDA installed?
>>>
>>>> CCed Luis in case he has anything to add.
>>
>> Yea not sure if debian ships crda and wireless-regdb yet.
>
> I'm running debian unstable and haven't seen crda yet.

Kel, curious if you might be aware of the debian's packaging status of
CRDA and wireless-regdb. Also can you recommend a kernel contact, I'd
like to recommend to not use CONFIG_WIRELESS_OLD_REGULATORY for a few
reasons [1] as it seems to be the default on the current 2.6.32
kernel.

[1] http://wireless.kernel.org/en/developers/Regulatory#Old_regulatory_implementation

  Luis
