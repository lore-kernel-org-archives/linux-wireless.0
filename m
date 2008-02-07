Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.251]:8591 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971AbYBGNt6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2008 08:49:58 -0500
Received: by an-out-0708.google.com with SMTP id d31so800033and.103
        for <linux-wireless@vger.kernel.org>; Thu, 07 Feb 2008 05:49:55 -0800 (PST)
Message-ID: <912ec82a0802070549q11d76e5di403fd0c6795b3ee3@mail.gmail.com> (sfid-20080207_135004_759188_51A00A16)
Date: Thu, 7 Feb 2008 15:49:55 +0200
From: "Neshama Parhoti" <pneshama@gmail.com>
To: "Holger Schurig" <hs4233@mail.mn-solutions.de>
Subject: Re: Getting Started
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200802071435.17254.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <912ec82a0802070511y734f9836q244abb7800210961@mail.gmail.com>
	 <200802071435.17254.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Holger,

On Feb 7, 2008 3:35 PM, Holger Schurig <hs4233@mail.mn-solutions.de> wrote:
> > Can you please point me to known good knowledge
> > references/overviews/tutorials on the subject ?
>
> Get a linux kernel via git. Look at the drivers in
> drivers/net/wireless. Some of them use mac80211, you can find
> out which one by looking at Kconfig there, e.g. when they have a
> line "depends on MAC80211" there.

Ok, thanks.

> It also helps when you share more about your incentives.

Currently I'm only studying the subject, so no specific hardware,
I will probably write preliminary driver just for education, so I don't
care if someone is working on it now.
