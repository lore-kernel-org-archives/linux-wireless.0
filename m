Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40671 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414Ab1LMIhA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Dec 2011 03:37:00 -0500
Subject: Re: Concurrent Mode Mutiple VIF question
From: Johannes Berg <johannes@sipsolutions.net>
To: Ajit Pal Singh <ajitpallearn@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CAFeFRo=rcrOnh1J84=XMWSyj8EzjMGYXetH1YkEiWBHBxz=3jQ@mail.gmail.com> (sfid-20111213_093511_419140_2B06202B)
References: <CAFeFRo=rcrOnh1J84=XMWSyj8EzjMGYXetH1YkEiWBHBxz=3jQ@mail.gmail.com>
	 (sfid-20111213_093511_419140_2B06202B)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Dec 2011 09:36:56 +0100
Message-ID: <1323765416.3355.1.camel@jlt3.sipsolutions.net> (sfid-20111213_093704_915184_60670167)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-12-13 at 14:04 +0530, Ajit Pal Singh wrote:
> Dear Community,
> 
> I am trying to implement Multiple Virtual Interface support for a
> hardware which can support mulitple channels per hardware
> concurrently.( For ex : AP and STA concurrently on different channels)
> .
> However I cannot find support for channels being configured per VIF.
> Could you please help me in understanding if I can support different
> channels per VIF in the current mac80211 implementation.

It's not yet supported. I'll be working on it early next year though.

johannes

