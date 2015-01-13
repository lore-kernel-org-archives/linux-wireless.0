Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:40204 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbbAMNul (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2015 08:50:41 -0500
Received: by mail-wg0-f50.google.com with SMTP id a1so3030664wgh.9
        for <linux-wireless@vger.kernel.org>; Tue, 13 Jan 2015 05:50:40 -0800 (PST)
Message-ID: <54B522AC.6050901@gmail.com> (sfid-20150113_145045_993386_4743A738)
Date: Tue, 13 Jan 2015 14:50:36 +0100
From: wim torfs <wtorfs@gmail.com>
MIME-Version: 1.0
To: Avinash Patil <patila@marvell.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: mwifiex - question
References: <1421065496-1968-1-git-send-email-patila@marvell.com>,<54B51EF1.60200@gmail.com> <CBACCFA0AEB13A41977475BCF3E896FC66736E7AC0@SC-VEXCH2.marvell.com>
In-Reply-To: <CBACCFA0AEB13A41977475BCF3E896FC66736E7AC0@SC-VEXCH2.marvell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Avinash,

Thanks for the clarification.
Obviously I missed the most important part of the path, which caused the 
confusion.

Thanks,
Wim.


On 01/13/2015 02:44 PM, Avinash Patil wrote:
> Hi Wim,
>
> Mwifiex is FullMac driver; we have our own thick FW for managing MLME.  This is reason why we do not use mac80211.
> Mwifiex is very much located under drivers/net/wireless; its not in net/wireless. net/wireless has cfg80211 driver.
>
> Thanks,
> Avinash.
> ________________________________________
> From: linux-wireless-owner@vger.kernel.org [linux-wireless-owner@vger.kernel.org] On Behalf Of wim torfs [wtorfs@gmail.com]
> Sent: Tuesday, January 13, 2015 7:04 PM
> To: linux-wireless@vger.kernel.org
> Subject: mwifiex - question
>
> Hi,
>
> I just noticed - from the mails passing through - that mwifiex is
> located in net/wireless and that it contains its own functions besides
> those of mac80211, while the description on the wiki mentions that it is
> a driver for Marvell SDIO chips.
>
> Is there any specific reason why it is not using mac80211 and why it is
> located in net/wireless instead of drivers/net/wireless, or is this an
> artifact of past choices that need to be cleaned up?
>
> Thanks,
> Wim.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
