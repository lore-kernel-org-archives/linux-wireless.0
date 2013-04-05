Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:38791 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab3DELvj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 07:51:39 -0400
Received: by mail-lb0-f177.google.com with SMTP id r10so3605907lbi.8
        for <linux-wireless@vger.kernel.org>; Fri, 05 Apr 2013 04:51:38 -0700 (PDT)
Message-ID: <515EBABB.2030104@gmail.com> (sfid-20130405_135142_933587_62627063)
Date: Fri, 05 Apr 2013 13:51:23 +0200
From: Pontus Fuchs <pontus.fuchs@gmail.com>
MIME-Version: 1.0
To: Solomon Peachy <pizza@shaftnet.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: RFCv5: ST-E CW1200 WLAN driver
References: <1363905589-8350-1-git-send-email-pizza@shaftnet.org> <20130402191327.GA9444@shaftnet.org>
In-Reply-To: <20130402191327.GA9444@shaftnet.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-04-02 21:13, Solomon Peachy wrote:
> On Thu, Mar 21, 2013 at 06:39:34PM -0400, Solomon Peachy wrote:
>> I'm satisfied with this driver from a functional standpoint (it handles
>> everything I'm able throw at it) so I'd really like to kick this thing
>> upstairs into wireless-next, assuming it passes muster.
>
> ...anything?

FWIW I just smoke tested this on a U8500 based device. No problems seen.

I agree that this thing is ready for merging.

Cheers,

Pontus

