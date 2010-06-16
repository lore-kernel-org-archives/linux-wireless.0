Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:36863 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932Ab0FPEhU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jun 2010 00:37:20 -0400
Received: by pva4 with SMTP id 4so480471pva.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jun 2010 21:37:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1276656060.26299.23.camel@emiko>
References: <1276649713.6127.276.camel@emiko> <AANLkTikp4M3Pnh0FEYEayo75FMY8M8j4OaByiiV6EAXJ@mail.gmail.com>
	<1276656060.26299.23.camel@emiko>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 15 Jun 2010 21:36:58 -0700
Message-ID: <AANLkTikUFtsqjGV9oAFkPhceeHzFlfs98psdAPBE5z2N@mail.gmail.com>
Subject: Re: [PATCH] ipw2200: Enable LED by default
To: Leann Ogasawara <leann.ogasawara@canonical.com>
Cc: reinette.chatre@intel.com, ilw@linux.intel.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	TJ <ubuntu@tjworld.net>, BrianK.Lee@atheros.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 15, 2010 at 7:41 PM, Leann Ogasawara
<leann.ogasawara@canonical.com> wrote:
> On Tue, 2010-06-15 at 18:20 -0700, Luis R. Rodriguez wrote:
>> On Tue, Jun 15, 2010 at 5:55 PM, Leann Ogasawara
>> <leann.ogasawara@canonical.com> wrote:
>> > Hi All,
>> >
>> > As documented in 2005 in Documentation/networking/README.ipw2200, "The
>> > LED code has been reported to hang some systems when running ifconfig
>> > and is therefore disabled by default."  We've however been carrying the
>> > following patch in our Ubuntu kernel for quite some time which enables
>> > the ipw2200 LED by default.  This was a result of numerous user
>> > requests.  We've seen no subsequent bug reports of systems hanging due
>> > to the the LED code being enabled by default.  I'd therefore like to
>> > propose the following patch to enable the LED by default.  This patch
>> > was originally authored by TJ.  I apologize in advance that I do not
>> > have TJ's full first and last name for provenance.
>> >
>> > Thanks,
>> > Leann
>> >
>> > >From 315246037a0edab4d626de6ccb68c73d3fe61ce3 Mon Sep 17 00:00:00 2001
>> > From: ubuntu@tjworld.net <ubuntu@tjworld.net>
>> > Date: Mon, 23 Mar 2009 20:29:28 +0000
>> > Subject: [PATCH] ipw2200: Enable LED by default
>> >
>> > BugLink: http://bugs.launchpad.net/bugs/21367
>> >
>> > Enable LED by default and update the MODULE_PARM_DESC.  The original
>> > reason for defaulting to disabled was documented in 2005 and noted, "The
>> > LED code has been reported to hang some systems when running ifconfig
>> > and is therefore disabled by default."  This no longer appears
>> > applicable and users have been requesting this be enabled for several
>> > years.
>> >
>> > Originally-by: TJ <ubuntu@tjworld.net>
>>
>> Does Originally-by also imply he has read the Certificate of Origin
>> and that he agrees for his code to be used in that way? That is the
>> purpose of the SOB anyway, but if you took his code, does that imply
>> that he agrees to it too?
>
> I'd CC'd TJ on the initial email, so I'm hoping he will respond here to
> your inquiry.  I can say that he had submitted the original form of the
> patch to the Ubuntu kernel-team mailing list back in March, 2009:
>
> https://lists.ubuntu.com/archives/kernel-team/2009-March/005013.html
>
> In that original submission he did provide his official SOB.
>
> The patch was then applied with slight modification by Tim Gardner to
> the Ubuntu kernel.  In forwarding this upstream, I wanted to give TJ the
> proper credit for originating the patch even though it's undergone some
> slight modification (ie the MODULE_PARM_DESC change).  TJ had not
> officially signed off on this final form of the patch which is the
> reason I used "Originally-by:".  If there is a better approach please
> let me know.

In that case I would just recommend to keep his original SOB, then it
would go through you/tim whoever it goes through until it reaches
Linus. But just my $0.02.

  Luis
