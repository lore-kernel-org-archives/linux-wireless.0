Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:58216 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbZCRAHm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2009 20:07:42 -0400
Received: by yw-out-2324.google.com with SMTP id 3so250484ywj.1
        for <linux-wireless@vger.kernel.org>; Tue, 17 Mar 2009 17:07:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1237329125.5100.7.camel@johannes.local>
References: <86201b3f0903171526l62258146q3f9fb15166813484@mail.gmail.com>
	 <1237329125.5100.7.camel@johannes.local>
Date: Tue, 17 Mar 2009 17:07:40 -0700
Message-ID: <43e72e890903171707o3365f243y68e080ece6afabaa@mail.gmail.com> (sfid-20090318_010744_551516_40365037)
Subject: Re: Support for country information
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Charles Gordon <digigordo@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 17, 2009 at 3:32 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2009-03-17 at 18:26 -0400, Charles Gordon wrote:
>> I'm writing a wireless driver that will use mac80211. =C2=A0I am dev=
eloping
>> with a 2.6.28-00106 version kernel.
>
> First of all, let me say that this is a mistake. The API is
> ever-evolving, and you want to develop against wireless-testing.

I'll add that if you are stuck on 2.6.28, then at least work off of
wireless-testing and consider compiling the modules on the systems
that are stuck on older kernels using compat-wireless [1]. This would
allow you to work using wireless-testing and get your 2.6.28 systems a
shiny new wireless system.

[1] http://wireless.kernel.org/en/users/Download

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
