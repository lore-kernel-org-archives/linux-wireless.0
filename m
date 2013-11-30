Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:58301 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab3K3SU0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Nov 2013 13:20:26 -0500
Received: by mail-ea0-f174.google.com with SMTP id b10so7587798eae.5
        for <linux-wireless@vger.kernel.org>; Sat, 30 Nov 2013 10:20:23 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "devendra.aaru" <devendra.aaru@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: unable to set iwlwifi master mode
Date: Sat, 30 Nov 2013 19:20:21 +0100
Message-ID: <1980481.3p2Oa8Hyrn@debian64> (sfid-20131130_192030_009267_E4E5D171)
In-Reply-To: <CAHdPZaN6GusQbpmNHt=4cHkUKsJTOrGuc0oBF7O8e0oL0neoPQ@mail.gmail.com>
References: <CAHdPZaN6GusQbpmNHt=4cHkUKsJTOrGuc0oBF7O8e0oL0neoPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Saturday 30 November 2013 12:26:11 devendra.aaru wrote:
> I was trying to use my intel wireless device as an AP. 
> 
> It seem to be that i couldn't able to get it working.
> 
> in case:
> 
> 03:00.0 Network controller: Intel Corporation Centrino Wireless-N 1000


> What could be the possible mistake?
Well, The latest version I found for the IWL 1000 was/is v39.31.5.1 Build
35138. It looks like this version doesn't "support" AP or P2P mode... and
it looks like it won't be coming.

You probably want to look for a replacement card. However, if you are using
a laptop, this might be difficult. Some vendor bios' have a wifi whitelist
and you have to ask your laptop vendor for the list first or "get creative".

Regards,

Christian
