Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:33564 "EHLO
	mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158AbcA3DJ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2016 22:09:28 -0500
MIME-Version: 1.0
In-Reply-To: <1454117303.10099.84.camel@perches.com>
References: <20160129172908.GA14077@Karyakshetra> <wrfjk2ms465z.fsf@redhat.com>
 <CAGRGNgWQvdfQc-L9z0NKCyCOorxU0seQ-XvYnZDBWA3QKySrRA@mail.gmail.com> <1454117303.10099.84.camel@perches.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Sat, 30 Jan 2016 14:09:08 +1100
Message-ID: <CAGRGNgU2EuY9fpe8rhHtA8OLDRC0s5=tcBStqpq=ZbMNrnuf0w@mail.gmail.com> (sfid-20160130_040945_143235_11488CBD)
Subject: Re: [PATCH] staging: rtl8723au: Fixes unnecessary return warning
To: Joe Perches <joe@perches.com>
Cc: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alexander Kuleshov <kuleshovmail@gmail.com>,
	Haneen Mohammed <hamohammed.sa@gmail.com>,
	Andreas Ruprecht <andreas.ruprecht@fau.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Joe,

On Sat, Jan 30, 2016 at 12:28 PM, Joe Perches <joe@perches.com> wrote:
> On Sat, 2016-01-30 at 10:17 +1100, Julian Calaby wrote:
>> On Sat, Jan 30, 2016 at 5:00 AM, Jes Sorensen <Jes.Sorensen@redhat.com> wrote:
>> > Bhaktipriya Shridhar <bhaktipriya96@gmail.com> writes:
>> > > This patch fixes checkpatch.pl warning in rtw_mlme_ext.c file.
>> > > WARNING: void function return statements are not generally useful
> []
>> > > diff --git a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c b/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
> []
>> > > @@ -2657,7 +2657,6 @@ static void issue_probersp(struct rtw_adapter *padapter, unsigned char *da)
>> > >
>> > >       dump_mgntframe23a(padapter, pmgntframe);
>> > >
>> > > -     return;
>> > >  }
>> >
>> > If you insist on pushing this rather unncessary change, please do it
>> > properly, and remove the blank line before the return statement as well.
>>
>> As Jes said, you need to remove the blank lines before the returns
>> too. checkpatch should have picked this up, you did run the patch
>> through checkpatch before you sent it, right?
>
> checkpatch doesn't pick this up.
>
> If you'd like to make it do so, you're welcome to try
> but it's likely a bit more complicated than it appears.

I meant the extra blank lines, not the useless return statements.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
