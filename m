Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:36706 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbbFKFsp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2015 01:48:45 -0400
Received: by pabqy3 with SMTP id qy3so47002044pab.3
        for <linux-wireless@vger.kernel.org>; Wed, 10 Jun 2015 22:48:45 -0700 (PDT)
Date: Thu, 11 Jun 2015 11:18:27 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Chris Park <chris.park@atmel.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, rachel.kim@atmel.com,
	dean.lee@atmel.com, johnny.kim@atmel.com
Subject: Re: [PATCH] staging: wilc1000: fix warning while printing
Message-ID: <20150611054827.GA3994@sudip-PC> (sfid-20150611_074849_352375_3709B017)
References: <1433994143-23363-1-git-send-email-chris.park@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1433994143-23363-1-git-send-email-chris.park@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 11, 2015 at 12:42:23PM +0900, Chris Park wrote:
> size_t should print using %zu, but here it was use %lu.
> we were getting warning while printing.
thanks, I made it to %lu seeing warning in x86_64 but that started
warning in i386. Not this solves warning in both.

regards
sudip
