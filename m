Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55915 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab0K3XHS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Nov 2010 18:07:18 -0500
Received: by wyb28 with SMTP id 28so6252644wyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 30 Nov 2010 15:07:16 -0800 (PST)
Message-ID: <4CF5839B.6060700@lwfinger.net>
Date: Tue, 30 Nov 2010 17:07:07 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: wireless in linux
References: <1D6034426110564DA0DEA9EE9793B38357E35E4823@NBE-MBX01.americas.swk.pri> <AANLkTimXDZLm7CAn7VyRPxQscTfHwTNALbDOh3LpjSQc@mail.gmail.com>
In-Reply-To: <AANLkTimXDZLm7CAn7VyRPxQscTfHwTNALbDOh3LpjSQc@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/30/2010 04:16 PM, Luis R. Rodriguez wrote:

> http://lmgtfy.com/?q=Linux+wireless

Good one.

I have a separate question about compat-wireless. I need to backport to kernel
2.6.21. I have fixed most of the problems, but I'm stuck on the case where
something has been added to a struct since that kernel. I looked at all the
compat-XXX patches, but I don't see what has been done previously. Is that
written up somewhere, or is there a prescription?

Thanks,

Larry
