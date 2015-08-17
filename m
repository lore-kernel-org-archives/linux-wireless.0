Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f182.google.com ([209.85.160.182]:34341 "EHLO
	mail-yk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbbHQOj5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2015 10:39:57 -0400
MIME-Version: 1.0
In-Reply-To: <20150817090828.GB5558@mwanda>
References: <cover.1439702894.git.raphael.beamonte@gmail.com>
 <641be2615e97db253a306c766a48c2afccf338d7.1439702894.git.raphael.beamonte@gmail.com>
 <20150817090828.GB5558@mwanda>
From: =?UTF-8?Q?Rapha=C3=ABl_Beamonte?= <raphael.beamonte@gmail.com>
Date: Mon, 17 Aug 2015 10:39:37 -0400
Message-ID: <CAE_Gge0m4KRC7UJntqnsXPeO9HZ7dg9UexLAi__2EN+ouGGw9w@mail.gmail.com> (sfid-20150817_164023_204398_EE303CA2)
Subject: Re: [PATCH 1/3] staging: wilc1000: code style: fix macro with
 multiple statements
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2015-08-17 5:08 GMT-04:00 Dan Carpenter <dan.carpenter@oracle.com>:
> Pull it in one indent level...  But actually this macro has a return in
> the middle of it, so it just introduces bugs all over the place like
> eating cookies in bed.  We should just delete it instead.

You're right!
I'll clean those macro up and send a new set of patches to replace this one.

Thanks for the feedback!
Raphaël
