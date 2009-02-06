Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cp-out10.libero.it ([212.52.84.110]:46352 "EHLO
	cp-out10.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbZBFTPG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2009 14:15:06 -0500
From: Fabio Rossi <rossi.f@inwind.it>
To: linux-wireless@vger.kernel.org
Subject: Re: ath5k: problems with wireless network data transfer
Date: Fri, 6 Feb 2009 20:02:02 +0100
Cc: Tim Hawkins <tim.hawkins@mac.com>,
	Nick Kossifidis <mickflemm@gmail.com>
References: <200902050010.27428.rossi.f@inwind.it> <40f31dec0902041519t5dcab35n19e6a0ec1642eaa5@mail.gmail.com> <5BAE77E6-F36F-4A54-A67E-FA10FF2FA599@mac.com>
In-Reply-To: <5BAE77E6-F36F-4A54-A67E-FA10FF2FA599@mac.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200902062002.04579.rossi.f@inwind.it> (sfid-20090206_201510_935010_E60C5E8E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 05 February 2009, Tim Hawkins wrote:

> this problem has been around for some time, users of the "aspire one"
> know to turn off the ath5k driver
> and use a branch of the madwifi driver patched with AR242x support,
> otherwise wireless networking is completely unreliable.
>
> The problem appears to be poor support for ar242x in the current in
> the wild version in most popular distros.
>
> The ath5k drive will load and appear to work, but is so flaky that it
> is virtually unusable.

Thanks for reporting the links where are described similar problems. You have 
a AR242x chip, from what I have understood the MAC+PHY part is common to my 
AR5212. So the problem could be related to the MAC management inside ath5k. I 
don't know if it's related by here I can see 5 AP, maybe the medium is too 
crowded.
