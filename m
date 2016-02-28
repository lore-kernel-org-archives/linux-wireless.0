Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755111AbcB1XBy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Feb 2016 18:01:54 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: dsadsa sadsad <natserver2@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: alfa awus036nhr v2 and module rtl8xxxu
References: <loom.20160128T003525-188@post.gmane.org>
	<wrfjd1sco25f.fsf@redhat.com> <56B38CDF.9010806@lwfinger.net>
	<wrfjd1scmkz6.fsf@redhat.com> <wrfj60xxd2f5.fsf@redhat.com>
	<56BA8E5D.5090402@lwfinger.net> <wrfjlh6tb9zt.fsf@redhat.com>
	<CAOhKHAXH-PCyWQSpuuZ=-6BnE0PeDks-4p9A3G_86OHLfEdU=w@mail.gmail.com>
	<56BB5C16.8070206@lwfinger.net>
Date: Sun, 28 Feb 2016 18:01:52 -0500
In-Reply-To: <56BB5C16.8070206@lwfinger.net> (Larry Finger's message of "Wed,
	10 Feb 2016 09:49:42 -0600")
Message-ID: <wrfjk2lomobj.fsf@redhat.com> (sfid-20160229_000157_806307_24A17050)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:
> On 02/10/2016 06:01 AM, dsadsa sadsad wrote:
>> So do i have to patch and recompile or not?
>
> It will not change a thing for the AWUS036NHR. It will fix a bug in
> 1T2R devices.

After pulling my hairs out over this one for days (if not weeks), I
think I finally figured it out.

I just pushed a patch into the rtl8xxxu-nextgen repository which makes
the AWUS036NHR v2 work for me.

Jes
