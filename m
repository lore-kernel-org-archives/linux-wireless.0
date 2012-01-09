Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:59890 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932266Ab2AIRTj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jan 2012 12:19:39 -0500
Received: by obcwo16 with SMTP id wo16so4353935obc.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jan 2012 09:19:39 -0800 (PST)
Message-ID: <4F0B21A7.10009@lwfinger.net> (sfid-20120109_181942_763426_F2B0951F)
Date: Mon, 09 Jan 2012 11:19:35 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: lina <lina.lastname@gmail.com>
Subject: Re: modprob b43 not work after hilibernate
References: <4F09AAE5.2080209@gmail.com>	<4F09BEC0.7080702@lwfinger.net>	<4F09C1E2.6020907@gmail.com> <CACna6rxMPnn1DHtMvsHtCG3y=_-sCKgb=L901MV96fj31BZ58A@mail.gmail.com> <4F0A686F.9050802@gmail.com>
In-Reply-To: <4F0A686F.9050802@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/08/2012 10:09 PM, lina wrote:
> On Monday 09,January,2012 05:44 AM, Rafał Miłecki wrote:
>> Does your kernel have
>> [PATCH] bcma: support for suspend and resume
>> applied?
>
> I don't know how to check, googled for a while, found some thread, but did not
> find the patch, is it in the kernel.org [patch] part, I thought the [full
> source] is already patched?

The mainline kernel v3.2-3191-g36e9db2 has that patch.

Larry

