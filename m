Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:54487 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbZDGU7X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2009 16:59:23 -0400
Received: by wf-out-1314.google.com with SMTP id 29so2962669wff.4
        for <linux-wireless@vger.kernel.org>; Tue, 07 Apr 2009 13:59:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1239137614.8456.10.camel@johannes.local>
References: <1239048958-11775-1-git-send-email-lrodriguez@atheros.com>
	<1239048958-11775-4-git-send-email-lrodriguez@atheros.com>
	<1239099071.22453.12.camel@johannes.local> <20090407162345.GC5758@tesla>
	<1239131370.6199.0.camel@johannes.local> <43e72e890904071338q4f9667ddo2958067c57442888@mail.gmail.com>
	<1239136863.7475.66.camel@johannes.local> <43e72e890904071344v30c663c5sb50937ce54e1b92b@mail.gmail.com>
	<1239137614.8456.10.camel@johannes.local>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 7 Apr 2009 13:59:07 -0700
Message-ID: <43e72e890904071359g1108dc42tca7e7fa06fb3a830@mail.gmail.com> (sfid-20090407_225927_766917_B5406A40)
Subject: Re: [PATCH v2 3/5] mac80211: check if HT40+/- is allowed before
	sending assoc
To: Johannes Berg <johannes@sipsolutions.net>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 7, 2009 at 1:53 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2009-04-07 at 13:44 -0700, Luis R. Rodriguez wrote:
>
>> >> That's what was there or what I added in my patches.
>> >
>> > Indeed, it's already there. I guess I got confused, sorry for the noise.
>>
>> hehe, np, are these ACKed now then?
>
> Yeah seems fine to me -- I'm happy as long as the userspace interface
> doesn't include all this :)

Thanks :)

 Luis
