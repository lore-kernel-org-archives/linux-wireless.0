Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:36315 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbbKBTfD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2015 14:35:03 -0500
Received: by wicfx6 with SMTP id fx6so56461277wic.1
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2015 11:35:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E8B86B4@hasmsx107.ger.corp.intel.com>
References: <CAD1M061nR5s6MFLHtoYDk05Ewz_3SHevB6s7qTB59qz681NLUg@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB32E8B86B4@hasmsx107.ger.corp.intel.com>
From: Pushpal Sidhu <psidhu@gateworks.com>
Date: Mon, 2 Nov 2015 11:34:32 -0800
Message-ID: <CAD1M060oOXup7MGAz2UCAi_mHEnQvsVtDEoNsoF2czcL7Q9D9w@mail.gmail.com> (sfid-20151102_203508_272281_539B6F57)
Subject: Re: Intel 7260 - limited in 5GHz spectrum
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 31, 2015 at 12:12 PM, Grumbach, Emmanuel
<emmanuel.grumbach@intel.com> wrote:
> Hi,
>
> On 10/30/2015 06:37 PM, Pushpal Sidhu wrote:
>> Hi,
>>
>> I've been working with the Intel 7260 card which advertises itself as
>> dual band wireless AC card. However, I cannot get it working in AP
>> mode in the 5GHz range. An $(iw list) shows that the entire 5GHz band
>> has 'no IR' next to it so as not to allow device radiation (please see
>> pastebin here: http://pastebin.com/T4BWnBmn).
>>
>> After searching around the internet a bit, it seems that the card
>> doesn't allow for this mode (And is thus not really dual band?). I'd
>> like to know if this is a firmware limitation and if there's a fix in
>> place, or if not, why is this card limited to the spectrum it can
>> radiate at?
>>
>
>
> 7260 does not (and will not) support AP mode in 5GHz band. This is of
> course not a hardware limitation since it can function as a station in
> this band. The limitation is due to regulatory concerns. Later devices
> (8260) have the ability to be an AP in 5GHz under certain circumstances.

Ah, thank you for the clarification.

- Pushpal
