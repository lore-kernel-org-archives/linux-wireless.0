Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39214 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934678AbbI2KmJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2015 06:42:09 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net
Subject: Re: [PATCH 1/1] New driver: rtl8723au (mac80211)
References: <1427142300-28051-1-git-send-email-Jes.Sorensen@redhat.com>
	<1427142300-28051-2-git-send-email-Jes.Sorensen@redhat.com>
	<87383kps0o.fsf@kamboji.qca.qualcomm.com>
	<wrfjvbggfhuj.fsf@redhat.com>
	<8737yrhdm0.fsf@kamboji.qca.qualcomm.com>
	<wrfjlhcidq9b.fsf@redhat.com>
	<87io6t7gdt.fsf@kamboji.qca.qualcomm.com>
Date: Tue, 29 Sep 2015 06:42:07 -0400
In-Reply-To: <87io6t7gdt.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
	of "Tue, 29 Sep 2015 11:56:46 +0300")
Message-ID: <wrfjoaglld6o.fsf@redhat.com> (sfid-20150929_124223_400742_4D4DB804)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:
> Jes Sorensen <Jes.Sorensen@redhat.com> writes:
>
>>>>> I doubt that this will be in active enough development that a separate
>>>>> git tree is needed. wireless-drivers trees should be enough and this
>>>>> line can be removed.
>>>>
>>>> I would like to keep this line, it points to my development tree, which
>>>> allows users to go back and look through my full development logs, as
>>>> well as see ongoing work before it's pushed upstream.
>>>
>>> I prefer that wireless-drivers(-next).git is used as the baseline for
>>> wireless driver patches, so please remove this tag. You can document
>>> your git server in the wiki, commit log and so on.
>>
>> I will insist on keeping my branch listed as long as I maintain the
>> driver. Other drivers do the same thing, like iwlwifi. I'm happy to send
>> you patches against wireless-drivers-next.git though.
>
> To keep things simple for me I want that the patches are based on
> wireless-drivers-next.git. iwlwifi is under so active development that
> an extra tree is justified, but having a dedicated tree for a not so
> active driver is just extra work for me which I do not want to have.
>
> With rtlwifi it goes so that Larry acks the patches on the list and
> patchwork automatically adds the ack to the commit log when I apply the
> patch, which is easy and fast for everyone. The same should go with
> rtl8723au.

The rtl8xxxu branch is there because that is where I do the active
development, and work actively on the driver. If people post patches for
it and it's smaller fixes, sure just take them, if they post larger
changes, please punt them to me and I will integrate them and send them
on to you.

Jes
