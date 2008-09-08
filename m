Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:4503 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbYIHJcQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 05:32:16 -0400
Received: by yw-out-2324.google.com with SMTP id 9so146328ywe.1
        for <linux-wireless@vger.kernel.org>; Mon, 08 Sep 2008 02:32:15 -0700 (PDT)
Message-ID: <1ba2fa240809080232n42d6caefs6c3a1f5afef46cb4@mail.gmail.com> (sfid-20080908_113220_558913_B23ACAE8)
Date: Mon, 8 Sep 2008 12:32:14 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC PATCH 0/3] mac80211 dissasociation
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1220865843.31304.48.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1220739259-16918-1-git-send-email-tomas.winkler@intel.com>
	 <1ba2fa240809070724n362d5850t653ca5746b87eb48@mail.gmail.com>
	 <1220798432.31304.13.camel@johannes.berg>
	 <1ba2fa240809070750k1683f410icf2a82be0f533b4f@mail.gmail.com>
	 <1ba2fa240809071614v66235658w1768e31d31c2d0f8@mail.gmail.com>
	 <1220863139.31304.33.camel@johannes.berg>
	 <1ba2fa240809080146o93200eetcf8e142f6ef4a2b1@mail.gmail.com>
	 <1220864314.31304.38.camel@johannes.berg>
	 <1ba2fa240809080206u42908ef6yc6641435d747155a@mail.gmail.com>
	 <1220865843.31304.48.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 8, 2008 at 12:24 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2008-09-08 at 12:06 +0300, Tomas Winkler wrote:
>
>> > How exactly are you triggering that "unauthorized port" message? I can't
>> > seem to reproduce to see if stopping the queue helps, but I'm fairly
>> > sure, try the patch below that fixes this.
>>
>> Powering off AP, I think I've seen only Cisco AP that are able to send
>> deauth packet on power off. So this was without.
>
> Alright, I have an AP where I can log in and turn off the radio :))
>
> I've been able to trigger the message _without_ your patches, but not
> _with_ your patches so far!
>
> I still think we should add the queue stopping so we can't run into the
> messages. Do you want me to send them out then?

I've added new commit message to the first patch and the new hunk
otherwise no changes.
I want to test your stopping queue stuff in my environment  but I get
to the lab only very late today.
Thanks for your effort
Tomas
