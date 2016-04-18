Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:34465 "EHLO
	mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbcDRQDz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2016 12:03:55 -0400
Received: by mail-oi0-f66.google.com with SMTP id b10so1226957oig.1
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2016 09:03:55 -0700 (PDT)
Subject: Re: [PATCH 00/16] rtl8xxxu prepare for splitting into multiple files
To: Jes.Sorensen@redhat.com, linux-wireless@vger.kernel.org
References: <1460994576-24091-1-git-send-email-Jes.Sorensen@redhat.com>
Cc: kvalo@codeaurora.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <57150569.5090009@lwfinger.net> (sfid-20160418_180359_642217_7B81D309)
Date: Mon, 18 Apr 2016 11:03:53 -0500
MIME-Version: 1.0
In-Reply-To: <1460994576-24091-1-git-send-email-Jes.Sorensen@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/18/2016 10:49 AM, Jes.Sorensen@redhat.com wrote:
> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>
> Hi,
>
> This is the last set of patches I have in my queue for the rtl8xxxu
> driver, as of today :)
>
> Since the driver has grown to support quite a number of different
> chips, I want to split it into multiple files. This will make it
> easier to maintain and also eaiser to add support for more chips
> without having to constantly touch the core files.
>
> This set renames a bunch of functions to indicate that they are
> generic rather than chip specific. I will look at doing the actual
> moving around in a set right after the current merge window closes.
>
> Please keep the test reports coming!

I like the renaming of the routines to match the chip generation, but there 
should be some comments stating the gen to which each device/version belongs. 
Such comments are not needed now, but could be included when the files are split.

Larry

