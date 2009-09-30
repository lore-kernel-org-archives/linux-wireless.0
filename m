Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:49678 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220AbZI3Mgi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2009 08:36:38 -0400
MIME-Version: 1.0
In-Reply-To: <4AC22B64.8050909@googlemail.com>
References: <4AC22B64.8050909@googlemail.com>
Date: Wed, 30 Sep 2009 13:36:40 +0100
Message-ID: <6278d2220909300536u7934d7dan286d219b5cf7e5a@mail.gmail.com>
Subject: Re: ath5k suspend
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Gonsolo <gonsolo@gmail.com>
Cc: kernel-team@lists.ubuntu.com,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Gonsolo,

On Tue, Sep 29, 2009 at 4:44 PM, Gonsolo <gonsolo@gmail.com> wrote:
> Hi!
>
> Is it possible to add
> http://patchwork.kernel.org/patch/38550/
> to karmic? Otherwise karmic would be broken for me/my notebook/my
> wireless pccard.

Since Karmic tracks the 2.6.31 -stable kernels, it's worth reporting
this upstream (CC'd) instead, particularly if it's a regression from a
previous kernel version, using the same ath5k driver...?

Then, it'll be in Karmic in ~ a few weeks.

Daniel
-- 
Daniel J Blueman
