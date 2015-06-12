Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:36317 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbbFLLHs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2015 07:07:48 -0400
Received: by pabqy3 with SMTP id qy3so21183342pab.3
        for <linux-wireless@vger.kernel.org>; Fri, 12 Jun 2015 04:07:48 -0700 (PDT)
Date: Fri, 12 Jun 2015 16:37:37 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Dean Lee <dean.lee@atmel.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, rachel.kim@atmel.com,
	chris.park@atmel.com, johnny.kim@atmel.com
Subject: Re: [PATCH] staging: wilc1000: update TODO list
Message-ID: <20150612110737.GA5436@sudip-PC> (sfid-20150612_130751_639243_031516DA)
References: <1434104591-5599-1-git-send-email-dean.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1434104591-5599-1-git-send-email-dean.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 12, 2015 at 07:23:11PM +0900, Dean Lee wrote:
> remove complete OS wrapper functions.
just a minor thing. It will be easy if you send your patches in series
instead of separate patches. your patch "remove oswrapper & type file"
is dependent on one of the previous patch that you have sent today. If
for some reason that previous patch is not applied then
"remove oswrapper & type file" will not apply and then this patch will
have no meaning.

regards
sudip

