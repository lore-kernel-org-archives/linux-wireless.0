Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:39275 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbbCHLEM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Mar 2015 07:04:12 -0400
MIME-Version: 1.0
In-Reply-To: <1425022290.11202.1.camel@coelho.fi>
References: <1423998550-8829-1-git-send-email-eliad@wizery.com>
	<1425022290.11202.1.camel@coelho.fi>
Date: Sun, 8 Mar 2015 13:04:11 +0200
Message-ID: <CAB3XZEcYFd-ho4rTcqT3xgaFn-W876QjLDcTqK96ho9Vaq4iAQ@mail.gmail.com> (sfid-20150308_120417_272759_AF59A590)
Subject: Re: [PATCH v2] wlcore: add basic device-tree support
From: Eliad Peller <eliad@wizery.com>
To: Luca Coelho <luca@coelho.fi>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Ido Yariv <ido@wizery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi Luca,

On Fri, Feb 27, 2015 at 9:31 AM, Luca Coelho <luca@coelho.fi> wrote:
> Hi,
>
> On Sun, 2015-02-15 at 13:09 +0200, Eliad Peller wrote:
>> When running with device-tree, we no longer have a board file
>> that can set up the platform data for wlcore.
>> Allow this data to be passed from DT.
>>
>> For now, parse only the irq used. Other (optional) properties
>> can be added later on.
>>
>> Signed-off-by: Ido Yariv <ido@wizery.com>
>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>> ---
>
> I don't really care much, but why not just finalize the work I did a
> couple of years ago?
>
> http://mid.gmane.org/1375189476-21557-1-git-send-email-coelho@ti.com
> http://mid.gmane.org/1375215668-29171-1-git-send-email-coelho@ti.com
>
> IIRC there were just some minor comments there, but I never really got
> to it because I left TI.

I just wanted a small patch to add DT support for wl18xx.
as there were some issues remaining wrt the correct way to specify the
clock data, i preferred taking the simpler route (for now), and only
add the wl18xx part, which doesn't require the clocks definitions.

i guess the patches will still be useful (and used) when wl12xx DT
support will be added.

Eliad.
