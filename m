Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f160.google.com ([209.85.217.160]:63008 "EHLO
	mail-gx0-f160.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbZC3Q6b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 12:58:31 -0400
MIME-Version: 1.0
In-Reply-To: <20090330085952.GB3837@linux.vnet.ibm.com>
References: <1231336282-22283-1-git-send-email-jirislaby@gmail.com>
	 <1231338965-796-1-git-send-email-jirislaby@gmail.com>
	 <20090107152208.GB4207@linux.vnet.ibm.com>
	 <4964CAAA.3040801@gmail.com>
	 <25891f3e0902012357n21e7bc2fmc59fb2a842631651@mail.gmail.com>
	 <20090215134702.GA10180@hash.localnet> <49A9C3D7.8060706@gmail.com>
	 <20090330085952.GB3837@linux.vnet.ibm.com>
Date: Mon, 30 Mar 2009 12:58:28 -0400
Message-ID: <b6c5339f0903300958m587cde69o44ae24d0609228ba@mail.gmail.com> (sfid-20090330_185835_437055_6E78A7CA)
Subject: Re: [PATCH 1/1] ath5k: fix hw rate index condition
From: Bob Copeland <me@bobcopeland.com>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Jiri Slaby <jirislaby@gmail.com>,
	Dhaval Giani <dhaval.lists@thegianis.in>,
	linville@tuxdriver.com, davem@davemloft.net,
	linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 30, 2009 at 4:59 AM, Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> Where is the fix? Is it merged in? I still see this happen on 2.6.29
>
> thanks,

It's in b726604706ad88d8b28bc487e45e710f58cc19ee in Linus' tree, after
2.6.29.  You still might get a warning, but this time from the driver
side instead of higher up the stack -- if you do please post it.

-- 
Bob Copeland %% www.bobcopeland.com
