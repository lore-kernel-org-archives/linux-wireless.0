Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f196.google.com ([209.85.221.196]:35088 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbZG3WbZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 18:31:25 -0400
Received: by qyk34 with SMTP id 34so1194893qyk.33
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2009 15:31:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A72113F.8000604@gmx.de>
References: <4A72113F.8000604@gmx.de>
Date: Thu, 30 Jul 2009 18:05:12 -0400
Message-ID: <b6c5339f0907301505yde9e457k4ddc87b1c9120a84@mail.gmail.com>
Subject: Re: ath5k: monitor mode needs channel change
From: Bob Copeland <me@bobcopeland.com>
To: Joerg Albert <jal2@gmx.de>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 30, 2009 at 5:31 PM, Joerg Albert<jal2@gmx.de> wrote:
> I currently need an extra trigger by changing the channel after
> "ifconfig up" to see any output in monitor mode from ath5k, e.g.

Does this (accidentally) fix it by chance?

http://patchwork.kernel.org/patch/38165/

It reloads the filters at ifup time.

-- 
Bob Copeland %% www.bobcopeland.com
