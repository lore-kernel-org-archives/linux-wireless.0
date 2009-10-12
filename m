Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f188.google.com ([209.85.210.188]:50807 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbZJLAKI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Oct 2009 20:10:08 -0400
Received: by yxe26 with SMTP id 26so3109253yxe.4
        for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2009 17:09:29 -0700 (PDT)
Message-ID: <4AD273B2.5000607@gmail.com>
Date: Sun, 11 Oct 2009 19:09:22 -0500
From: Quintin Pitts <geek4linux@gmail.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Christian Lamparter <chunkeey@web.de>
Subject: Re: [RFC] p54pci: skb_over_panic, soft lockup, stall under flood
References: <4AD1EBA7.904@gmail.com> <4AD1FA5E.1010201@lwfinger.net>
In-Reply-To: <4AD1FA5E.1010201@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun Oct 11 2009 10:31:42 GMT-0500 (CDT), Larry Finger wrote:
> On 10/11/2009 09:28 AM, Quintin Pitts wrote:
>> Hi,
>>
>> Sorry for my lack of experience in all aspects - first time
>> submitting!!!
> 
> Everyone that goes through this "right of passage" gets somewhat
> discouraged by the response. My advice is to hang in.
> 
> My first advice is for you to run every submitted patch through the
> check at scripts/checkpatch.pl. This one shows 95 errors and 7
> warnings in 136 lines. Most of the errors are due to "DOS line
> endings". We really hate carriage returns - a really useless occupier
> of space unless it is _NOT_ followed by \n!

Thanks for the advice!
 

> As I understand it, this patch is to fix the driver to work around
> firmware errors. If that is correct, please state that clearly. If
> only partially correct, then indicate which parts are to fix firmware
> errors, and which are to fix driver errors. Has your analysis included
> thinking about where the driver might delay to avoid firmware problems.

I think Christian has hit the nail on the head.  Mostly flaky hardware
or implementation (it8152 pci bridge) when pushed.

> 
> I will let Christian comment more on the technical merits of the patch
> as he understands the device much better than I do.
> 
> Larry

Thanks,

Quintin.
