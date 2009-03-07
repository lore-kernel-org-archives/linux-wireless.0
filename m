Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:3587 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877AbZCGVT6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Mar 2009 16:19:58 -0500
Received: by wf-out-1314.google.com with SMTP id 28so1185277wfa.4
        for <linux-wireless@vger.kernel.org>; Sat, 07 Mar 2009 13:19:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090307192529.GB6648@tuxdriver.com>
References: <1236316387-9718-1-git-send-email-lrodriguez@atheros.com>
	 <1236316387-9718-2-git-send-email-lrodriguez@atheros.com>
	 <43e72e890903061409h1cc9f1a2r501fd44a05b8c786@mail.gmail.com>
	 <43e72e890903061905g6a2bff1bld0232e05409643b9@mail.gmail.com>
	 <20090307192529.GB6648@tuxdriver.com>
Date: Sat, 7 Mar 2009 13:19:57 -0800
Message-ID: <43e72e890903071319h6435ddfbw44293e9f97495176@mail.gmail.com> (sfid-20090307_222003_148714_F208A6BE)
Subject: Re: [PATCH 2/2] mac80211_hwsim: add regulatory_hint support
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: j@w1.fi, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 7, 2009 at 11:25 AM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Fri, Mar 06, 2009 at 07:05:30PM -0800, Luis R. Rodriguez wrote:
>> On Fri, Mar 6, 2009 at 2:09 PM, Luis R. Rodriguez
>> <lrodriguez@atheros.com> wrote:
>> > On Thu, Mar 5, 2009 at 9:13 PM, Luis R. Rodriguez
>> > <lrodriguez@atheros.com> wrote:
>> >> ACME Inc. only sells these in Finland.
>> >
>> > On second thought this is not such a good idea as simply loading i=
t
>> > would change your regulatory domain which is not the desired effec=
t
>> > for testing purposes. I will resend with some other things to avoi=
d
>> > undesired regulatory changes.
>>
>> I see this was merged already - its ok, I'll just send a patch on to=
p.
>
> It is only in wireless-testing -- I can still drop the original
> before sending to Dave. =C2=A0So, it is probably best to just send a
> replacement patch.

Sure, thanks,

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
