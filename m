Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37215 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588Ab0IQAK4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 20:10:56 -0400
Received: by iwn5 with SMTP id 5so1450005iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 16 Sep 2010 17:10:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1284682087-19351-1-git-send-email-vmehta@atheros.com>
References: <1284682087-19351-1-git-send-email-vmehta@atheros.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 16 Sep 2010 17:10:35 -0700
Message-ID: <AANLkTinPPuie4cUjdLcDD=tt_pfYVx9n+r3xvJKB2=tx@mail.gmail.com>
Subject: Re: [PATCH] staging: ath6kl: Including a header file to fix a
 compilation error
To: Vipin Mehta <vmehta@atheros.com>
Cc: greg@kroah.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 16, 2010 at 5:08 PM, Vipin Mehta <vmehta@atheros.com> wrote:
> The commit fixes a compilation error that was encountered while using a specific kernel configuration file. The problem was the use of some fuunctions defined in <linux/semaphore.h> without including the header file explicitly. It was probably working before because of the dependency getting implicitly satisfied via some other header file. Also, eliminating the inclusion of the same header file more than once. The code needs additional cleanup and may be addressed by a subsequent commit.

Keep the commit log lines to less than about 70 lines or so.

 Luis
