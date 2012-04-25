Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:38234 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756861Ab2DYKoJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2012 06:44:09 -0400
Received: by qatm19 with SMTP id m19so3400041qat.19
        for <linux-wireless@vger.kernel.org>; Wed, 25 Apr 2012 03:44:08 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUXG545mfc9aOYAKiLoNiYmUi3wj+5vkB_R_1jRSNSLk4A@mail.gmail.com>
References: <2F08FF0B-5C29-4827-AA5F-B0F3847D0B83@gmail.com>
	<8FBCAE90-FAE9-430D-888E-F055091E6683@gmail.com>
	<CANUX_P1OxH7rmYWxizEaf2DnPSTK0npNtZ2Q9Rm5dksnmFKD8g@mail.gmail.com>
	<9D52D4AD-58DC-4896-97FC-7248E1FD2614@gmail.com>
	<CANUX_P1ZX_e+0qs4sa7vdAqHvOQjO6+9PiFhDbW8ybE4ax80gQ@mail.gmail.com>
	<8EE08C44-8618-45EC-B890-B5B12B661FB6@gmail.com>
	<CANUX_P0O0-6sOaN59V_RxLj_DbiTdNdwq0zze6B6vMe1hfQuqA@mail.gmail.com>
	<37926591-261D-4C3E-A1D9-4A8AB3364F5D@gmail.com>
	<4F901224.1040508@sipsolutions.net>
	<EA757D90-2CCE-48A1-AF35-7F65EB45F7EE@gmail.com>
	<4F901F16.6080007@sipsolutions.net>
	<CAC79F14-24F2-4F90-8A47-B9B2744F5AE3@gmail.com>
	<CANUX_P2t86v0L=DDaaBdW-6Yb5ffSscv2aSy+jQ5dFc0TqWB_Q@mail.gmail.com>
	<CBC6370A-C51D-4CF6-99CE-AE8C35C467FB@gmail.com>
	<CANUX_P0RUv_d+A+uY5AZcb4Yo81+ihw_tPr4u2btAz66Pt_=0Q@mail.gmail.com>
	<04B86DB4-284B-4FA0-916F-75BF75863A5E@gmail.com>
	<CANUX_P2HP1PkPWR6=qW12bbRDtJpDY+5oYMbNajAXmJHjyjjuA@mail.gmail.com>
	<4F96939B.5030204@erley.org>
	<CA+icZUVWLyvSuGHUWsNZVmEZj84p4EppnZYTeaaU9-WF8g4AGw@mail.gmail.com>
	<D90BDD59-B256-445F-B9A3-F5481D57A5A7@gmail.com>
	<CA+icZUVmO7Ehim0FHVAEL37PMNSGhVNismAu1DoOwAbt1Rphzg@mail.gmail.com>
	<CANUX_P1HQVUFcxFLtWoL+wvEXbNTk0qEJVM+4yJKBbGuhWvZbw@mail.gmail.com>
	<CA+icZUUr9v-fc-86gAppJWF+c2PBE07eG28BNfQf+9ESvHqj=A@mail.gmail.com>
	<CANUX_P2yiz025rkcDsisNd0uFfEaVV=Gycf0fzWA29ct7R9aDg@mail.gmail.com>
	<CA+icZUXG545mfc9aOYAKiLoNiYmUi3wj+5vkB_R_1jRSNSLk4A@mail.gmail.com>
Date: Wed, 25 Apr 2012 12:44:07 +0200
Message-ID: <CA+icZUVEbbG2Wke1p2PxsgCQV+mHny+C+f4jRMnego+gWAVVZg@mail.gmail.com> (sfid-20120425_124414_005578_FF320809)
Subject: Re: wlan0 not present
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Dominik Feser <dominik.feser@googlemail.com>,
	Pat Erley <pat-lkml@erley.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	"Luis R. Rodriguez" <mcgrof@frijolero.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 25, 2012 at 9:34 AM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> On Wed, Apr 25, 2012 at 9:26 AM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>> On Wed, Apr 25, 2012 at 09:23, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
>>> On Tue, Apr 24, 2012 at 5:34 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>>>> On Tue, Apr 24, 2012 at 15:45, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
>>>>> On Tue, Apr 24, 2012 at 2:29 PM, Dominik Feser
>>>>> <dominik.feser@googlemail.com> wrote:
>>>>>> What does that mean?
>>>>>>
>>>>>
>>>>> Pickup the patch from [2], apply it against a recent compat-wireless
>>>>> version, build and test.
>>>>> Report here again.
>>>>>
>>>>
>>>> Pretty sure it won't help. True, we were trying to request the wrong
>>>> fw, but then we requested (and got) the good one, so that the only
>>>> effect was that load time was longer that it could be. But here, we
>>>> can't even get anything working. And the prints don't made it to
>>>> kernel log properly
>>>>
>>>
>>> Originally I answered Pat as he asked what's the status with the patch
>>> concerning the firmware-issue.
>>> So, my post was about applying this one (so I understood the open question).
>>> I didn't care about the original concern of the reporter.
>>> BTW, the mentioned patch is now in wireless.git (master-2012-04-24-2).
>>
>> fair enough :-)
>>
>>>
>>> Currently, I have an issue myself on iwlwifi (6230) with Ubuntu
>>> precise, but it looks like a bug in network-manager with 3.4-rc4+ (see
>>> [1]).
>>>
>>> - Sedat -
>>>
>>> [1] https://bugzilla.redhat.com/show_bug.cgi?id=785772
>>>
>>
>> Thanks for that pointer.
>
> My first bug-report to Ubuntu BTS.
>
> Don't want to tell you how much effort this was, not the bug-report itself.
> It started with...
>
> $ sudo ubuntu-bug $(pidof NetworkManager)
>
> ...on Debian I was used to file with report-bug.
>
> That was not enough, I had to register a LaunchPad-account and got a
> strange "DisplayName" and "OpenIdName".
> After some struggling I got both changed.
> There are really easier ways...
>
> - Sedat -
>
> [1] https://bugs.launchpad.net/bugs/988183

Just FYI:
I found the NM upstream commit which fixes Ubuntu's NetworkManager
version in precise release (debdiff attached to my BR).
The issue reminds me of many drakes (male) court a single duck's
(female) favour in the pairing season, sort of a witch-hunt, not
gentleman-alike.

- Sedat -
