Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:65195 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab2DXMpC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2012 08:45:02 -0400
Received: by qatm19 with SMTP id m19so2763653qat.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 Apr 2012 05:45:01 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <D90BDD59-B256-445F-B9A3-F5481D57A5A7@gmail.com>
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
Date: Tue, 24 Apr 2012 14:45:01 +0200
Message-ID: <CA+icZUVmO7Ehim0FHVAEL37PMNSGhVNismAu1DoOwAbt1Rphzg@mail.gmail.com> (sfid-20120424_144508_049829_59ABF5D9)
Subject: Re: wlan0 not present
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Dominik Feser <dominik.feser@googlemail.com>
Cc: Pat Erley <pat-lkml@erley.org>,
	Emmanuel Grumbach <egrumbach@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	"Luis R. Rodriguez" <mcgrof@frijolero.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 24, 2012 at 2:29 PM, Dominik Feser
<dominik.feser@googlemail.com> wrote:
> What does that mean?
>

Pickup the patch from [2], apply it against a recent compat-wireless
version, build and test.
Report here again.

- Sedat -

>
> Am 24.04.2012 um 14:07 schrieb Sedat Dilek:
>
>> On Tue, Apr 24, 2012 at 1:50 PM, Pat Erley <pat-lkml@erley.org> wrote:
>>> Try a newer compat-wireless.  I saw mention of a patch on this ML
>>> that iwlwifi was looking for firmwares that aren't available yet.
>>>
>>> Specifically, it wants a -6 ucode, where you have -5.  I'm not
>>> sure if this has been merged upstream yet.
>>>
>>
>> No, pending for upstream and linux-stable GIT, see [1] and especially
>> "iwlwifi: use correct released ucode version" [2].
>>
>> - Sedat -
>>
>> [1] http://git.kernel.org/?p=linux/kernel/git/iwlwifi/iwlwifi.git;a=shortlog;h=refs/heads/wireless
>> [2] http://git.kernel.org/?p=linux/kernel/git/iwlwifi/iwlwifi.git;a=patch;h=462156fac4d69483c1d54c6218d019681da8ad74
>
