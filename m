Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:34238 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913Ab0EJTJW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 15:09:22 -0400
Received: by pxi5 with SMTP id 5so1810428pxi.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 May 2010 12:09:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BE6FAED.4030407@redfish-solutions.com>
References: <4BE6FAED.4030407@redfish-solutions.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 10 May 2010 12:09:02 -0700
Message-ID: <u2x43e72e891005101209ud69f13b8se9af747434d877e4@mail.gmail.com>
Subject: Re: Jumbo frame messages?
To: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
Cc: wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 9, 2010 at 11:11 AM, Philip A. Prindeville
<philipp_subx@redfish-solutions.com> wrote:
> I'm running linux 2.6.27.42 with compat-wireless 2010-04-26 and using an
> AR-5413 card (ath5k).
>
> I'm also running hostapd 0.7.1 with WPA2 authentication.
>
> I'm seeing a lot of:
>
> May  9 12:07:21 pbx user.warn kernel: ath5k phy0: unsupported jumbo
>
> I thought this issue was resolved a while ago.
>
> Anyone have a root cause on this, or a workaround?

These frames should just be dropped and the warning removed.

 Luis
