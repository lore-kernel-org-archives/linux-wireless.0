Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:59157 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382AbXINTM5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2007 15:12:57 -0400
Received: by nf-out-0910.google.com with SMTP id g13so730055nfb
        for <linux-wireless@vger.kernel.org>; Fri, 14 Sep 2007 12:12:55 -0700 (PDT)
Message-ID: <46EADD21.7070607@gmail.com>
Date: Fri, 14 Sep 2007 21:12:33 +0200
From: dragoran <drago01@gmail.com>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: Johannes Berg <johannes@sipsolutions.net>, jt@hpl.hp.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: iwlist and network-manager bug report
References: <1189526874.6161.30.camel@johannes.berg>	 <1189610572.5644.28.camel@xo-3E-67-34.localdomain>	 <20070912170153.GA25785@bougret.hpl.hp.com>	 <1189667496.6161.77.camel@johannes.berg>	 <1189707493.1329.1.camel@johannes.berg> <1189793380.2508.2.camel@xo-3E-67-34.localdomain>
In-Reply-To: <1189793380.2508.2.camel@xo-3E-67-34.localdomain>
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams wrote:
> On Thu, 2007-09-13 at 20:18 +0200, Johannes Berg wrote:
>  =20
>> On Thu, 2007-09-13 at 09:11 +0200, Johannes Berg wrote:
>>
>>    =20
>>> Ok. I'll have to do some more extensive tests but in my last test w=
ith
>>> zd1211 it wouldn't display anything. Might be a different issue, bu=
t
>>> scanning manually showed things.
>>>      =20
>> Cool, I was totally wrong, seems the fact that it didn't display
>> anything was unrelated. I just tried again and NM 0.6.5 as shipped b=
y
>> debian/unstable actually manages to display the =C3=BC umlaut that i=
s
>> supposed to be the \xfc character.
>>
>> Btw. Will there ever be a 0.7 release? :)
>>    =20
>
> I've been burning the midnight oil on it for the past few weeks, chec=
k
> NM and applet changelogs.  Still not quite there yet, there's some co=
re
> work left to do getting NM to talk to the settings daemons (ie,
> nm-client or knetworkmanager) correctly, getting GUI bits for Connect=
ion
> editing in the applet, and making sure the relevant settings are
> honored.
>  =20
might be a bit OT but:
are you still planning to include it in F8 ? seems that the snapshot=20
didn't make it into test2 ..
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
