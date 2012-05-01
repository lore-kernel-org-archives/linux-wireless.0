Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ppa01.Princeton.EDU ([128.112.128.213]:49686 "EHLO
	ppa01.Princeton.EDU" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758334Ab2EARwq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 May 2012 13:52:46 -0400
Received: from csgsmtp201l.Princeton.EDU (csgsmtp201l.Princeton.EDU [128.112.134.60])
	by ppa01.Princeton.EDU (8.14.4/8.14.4) with ESMTP id q41HqjTD024001
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 1 May 2012 13:52:45 -0400
Received: from mail-lpp01m010-f46.google.com (mail-lpp01m010-f46.google.com [209.85.215.46])
	(authenticated bits=0)
	by csgsmtp201l.Princeton.EDU (8.13.8/8.12.9) with ESMTP id q41HqhuA018733
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 1 May 2012 13:52:45 -0400
Received: by lahj13 with SMTP id j13so2622277lah.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 May 2012 10:52:43 -0700 (PDT)
MIME-Version: 1.0
Reply-To: dchyan@princeton.edu
In-Reply-To: <CANUX_P3JrvyV7wXCkeXaS4k3GgcRxkSPW_5TGpqXFhrHKp5OYQ@mail.gmail.com>
References: <CAOvK7nAOHqKC8rpFDqGnW7NLCX-G2+syRGih_rv7N5O5rfOUdA@mail.gmail.com>
	<CANUX_P1t8XJOka-QGzZSYFHb6MLc7rm4madn059Yg4b6hJB49A@mail.gmail.com>
	<CAOvK7nDO4fS6R5go+ZXYBqyQc8hhbJGun9Weh=-EyX5k11+tXw@mail.gmail.com>
	<CANUX_P2rzvDCBVLmU2rfaZmUOCMuMDe5=TXE_jwxq4ULrvc=QQ@mail.gmail.com>
	<CAOvK7nCwRbDNZSnn0EvFMpcQMvX1DmU-tBuFT4kRW1TigwyJDQ@mail.gmail.com>
	<CANUX_P0JsyA53T_vs5Ea0pE5Ye4G9xRC4xKcdwgAmoC8E63sHg@mail.gmail.com>
	<CAOvK7nCf6k_ugJ=UBF8y0VBr_kVmESpetfnpn=NW73r_K=kKyw@mail.gmail.com>
	<CAOvK7nCGwqqqrWNQhPqZoBqs6eT11gQNYbrZhb0bNSPTS-YxEw@mail.gmail.com>
	<CANUX_P2DDQ-U9Yz2YksEEpOgjyyYO1GnFHR8ogEHNwojKvn3yg@mail.gmail.com>
	<CAOvK7nB0L9GcnV-cNONndZMrAVLfFf3VaY4T-gPb+FgrNByeSA@mail.gmail.com>
	<CANUX_P38L7OqBNeK+jO0EPMHf1M3QKxmsTA6o-t+6ujoq1VJ5w@mail.gmail.com>
	<CAOvK7nB1gnnWcv6HFrn1MhMe-FheRtdTpi+BhCcCYNx6RowaTQ@mail.gmail.com>
	<CANUX_P3SFmNKqUTt53EHkAjupAoB8ZxQZZP1osm7=JwfHnwbqg@mail.gmail.com>
	<CANUX_P1ivcpLxm4z5k8SU+hGXG0A1hbSMnps7_i025kaAThyCg@mail.gmail.com>
	<CAOvK7nBGBDWhQnq8MT51dE=LXUxoQH1FLJ2TNUr42He1KbBurg@mail.gmail.com>
	<CANUX_P25bU36A0n4YSO1mBUTn9pxYYua28=o9Soo12mVyZNVcQ@mail.gmail.com>
	<CANUX_P3+4hTGJSoo669LixMmNjxv1pqAwmLgVi16iF+LX7-ebQ@mail.gmail.com>
	<CAOvK7nA7=B_=kaQasYpwAegNG21GdxCuTZ5z+T7PMYPNaTxsXA@mail.gmail.com>
	<CANUX_P3JrvyV7wXCkeXaS4k3GgcRxkSPW_5TGpqXFhrHKp5OYQ@mail.gmail.com>
Date: Tue, 1 May 2012 13:52:43 -0400
Message-ID: <CAOvK7nAOGwdDbwCPPFg+2w4DiUv75ppY0wSK6rjUqaZGHHmk4g@mail.gmail.com> (sfid-20120501_195250_175293_F8D3E871)
Subject: Re: iwlwifi bug
From: Daniel Chyan <dchyan@princeton.edu>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Well I believe I can reproduce it by downgrading to an older driver,
but I am unable to reproduce it now.

On Mon, Apr 30, 2012 at 3:22 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
> On Mon, Apr 30, 2012 at 21:41, Daniel Chyan <dchyan@princeton.edu> wrote:
>> I am running iwlwifi with the additional flags. Nothing particularly
>> alarming has appeared in the logs, but I have attached it.
>>
>
> Yeah... I was hoping you could reliably reproduce the issue but
> apparently not :-)
