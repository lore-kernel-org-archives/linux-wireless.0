Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f170.google.com ([209.85.160.170]:35992 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbbJQJ7x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Oct 2015 05:59:53 -0400
Received: by ykdz2 with SMTP id z2so20798626ykd.3
        for <linux-wireless@vger.kernel.org>; Sat, 17 Oct 2015 02:59:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB6w8enLcU8LZfL=Uzpi5x6od_VExUdTW2PT9norQ=8POGNFcw@mail.gmail.com>
References: <CAB6w8enLcU8LZfL=Uzpi5x6od_VExUdTW2PT9norQ=8POGNFcw@mail.gmail.com>
From: Ramprasad Vempati <ramprasad.vempati@gmail.com>
Date: Sat, 17 Oct 2015 15:29:33 +0530
Message-ID: <CAB6w8ekg-6-p=ar=crbfDetHPG1bEsszgOKMAwVi2DTs5UL2rg@mail.gmail.com> (sfid-20151017_115955_887985_8BB8E27C)
Subject: Re: How to enforce Wireless Mode of Station?
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Can someone clarify?

Thanks,
Ram

On Thu, Oct 8, 2015 at 12:20 AM, Ramprasad Vempati
<ramprasad.vempati@gmail.com> wrote:
> Hi,
>
> I've been trying to find how to control wireless mode, i.e. 802.11b or
> 802.11g or 802.11ng or 802.11a etc for Station mode. In general for
> Station mode, the connection happens with AP based AP mode. But for
> test purpose, if I would like to control mode of a wireless station,
> is it possible?  I mean when AP is 11bgn mode, if I want STA to
> associate in 11b mode?
>
> I understand "iw" can be used to set rate mask. But I've tried with
> ath9k or intel chipsets. I've not been able to get it working as most
> of the vendors didn't implement this.
>
> Is there a different way to enforce specific wireless mode on station?
>
> Thanks,
> Ram
