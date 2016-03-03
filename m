Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:35637 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbcCCVBQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2016 16:01:16 -0500
Received: by mail-pa0-f48.google.com with SMTP id bj10so21303980pad.2
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2016 13:01:16 -0800 (PST)
Reply-To: arend@broadcom.com
Subject: Re: [PATCH V11 1/2] nl80211: add feature for BSS selection support
References: <1456947439-28968-1-git-send-email-arend@broadcom.com>
 <1457020529.2044.31.camel@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>,
	Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <56D8A618.4050707@broadcom.com> (sfid-20160303_220120_731104_968F9057)
Date: Thu, 3 Mar 2016 22:01:12 +0100
MIME-Version: 1.0
In-Reply-To: <1457020529.2044.31.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 3-3-2016 16:55, Johannes Berg wrote:
> On Wed, 2016-03-02 at 20:37 +0100, Arend van Spriel wrote:
>> Introducing a new feature that the driver can use to
>> indicate the driver/firmware supports configuration of BSS
>> selection criteria upon CONNECT command. This can be useful
>> when multiple BSS-es are found belonging to the same ESS,
>> ie. Infra-BSS with same SSID. The criteria can then be used to
>> offload selection of a preferred BSS.
>>
> Applied, finally :)
> 
> I moved the wiphy supported methods check into parse_bss_select() to
> avoid the double error path in the caller, plus some editorial changes.

Do you expect Kalle to take the brcmfmac patch or can it go through your
tree?

Regards,
Arend
