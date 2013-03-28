Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:34063 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab3C1K43 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Mar 2013 06:56:29 -0400
MIME-Version: 1.0
In-Reply-To: <20130328104030.GA4602@stt008.linux.site>
References: <CAKprTDHpf0PgisfJK9bJOYgYxLU5PRLNtbkg7V6Zj2s=gVVMCA@mail.gmail.com>
 <CAB=NE6Wbym4XksV=uKz9eZD0rZwmtS3ZfP-zbXg9TAc2+2+Z9g@mail.gmail.com>
 <CAKprTDEEEdy++Bk5AY4Zfrtwsc9HOKGQ+uWR58PFCWU=v+PE1g@mail.gmail.com>
 <CAB=NE6UtuxuTduYhDy5BcPap-rri+P1mcKYr2KEjAbuE2FU13g@mail.gmail.com>
 <20130327175711.GA8794@stt008.linux.site> <CAKprTDFspW4B2tk9EZPBBXy3C6gL_NJsjwj-bUeYj1rN3j6sYg@mail.gmail.com>
 <CAB=NE6W6Ey8iU1vs=XfA7Or0wF=Qh6Gu8zF-DxMatgk-V+wdkQ@mail.gmail.com>
 <CAKprTDFJet+m7RmkZt5uyf=FMyEYciCYUahEcCC6_ukRQ2pjgw@mail.gmail.com>
 <CAB=NE6VzvVkFvGaudZHQTM5R3s05QV5Jw23wZ_DLxkNf00Utdg@mail.gmail.com> <20130328104030.GA4602@stt008.linux.site>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Thu, 28 Mar 2013 03:56:08 -0700
Message-ID: <CAB=NE6V=AnTabh3p_yY+GmzPo-+GLAdzEBTQMm4VN1xUuVm_sw@mail.gmail.com> (sfid-20130328_115633_685329_B807B655)
Subject: Re: brcmsmac: Unknown symbol backport_cordic_calc_iq (err 0)
To: =?UTF-8?B?Q2FtYWxlw7Nu?= <noelamac@gmail.com>
Cc: "backports@vger.kernel.org" <backports@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Brett Rudley <brudley@broadcom.com>,
	Arend Van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	meuleman <meuleman@broadcom.com>, brcm80211-dev-list@broadcom.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 28, 2013 at 3:40 AM, Camaleón <noelamac@gmail.com> wrote:
> Now you say... can you please tell me -in user's parlance terms so I can
> understand it- what's the difference between "brcmsmac" from the stock
> kernel modules and this one from "compat-drivers"? I mean, what's the
> difference from a user's POV and from kernel hacker POV. Are they
> related? Are they going to me merged somehow? What's the goal of having
> both?

The releases annotated with a date come from linux-next. While Linus
is whipping people in shape for the RC releases in preparation for the
first official release we hounds still do some development. During the
RC cycle only regression fixes get merged into Linus' tree as well a
shiny new drivers as they do not regress. The development cycle
continues on without Linus. Stephen Rothwell maintains a tree that
sucks all development trees together daily, this is called linux-next.
We use linux-next for compat-drivers given that we backport not just
wireless but also drm. So by you using dated compat-drivers releases
you are using what's currently being developed and will likely hit
3.10.

  Luis
