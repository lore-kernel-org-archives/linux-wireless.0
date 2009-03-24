Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.229]:9557 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487AbZCXAkZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2009 20:40:25 -0400
Received: by rv-out-0506.google.com with SMTP id f9so2013074rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 23 Mar 2009 17:40:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49C82719.3080108@hauke-m.de>
References: <49C82719.3080108@hauke-m.de>
Date: Mon, 23 Mar 2009 17:40:08 -0700
Message-ID: <43e72e890903231740m6b804fa5mfdcfe57ae07702a7@mail.gmail.com> (sfid-20090324_014028_061566_9F9DF407)
Subject: Re: [PATCH] compat-2.6: Add AR9170 driver
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 23, 2009 at 5:19 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> This adds the AR9170 driver to compat-wireless.

Thanks applied and new tarball regenerated.

The patch commit log (which cannot be seen as the patch was attached)
only enables ar9170 for >= 2.6.28. If someone wants to get this on
2.6.27 you'll just have to backport the routines which fail to
compile. Patches welcomed of course.

v2.6.29-rc8-18695-g8fe80c6
wireless-testing latest tag:
master-2009-03-23
This is compat-release:
master-2009-03-23

One small note, Hauke, can you send these patches inline moving
forward? In this case it proved useful as the commit log had
information useful.

This may help, it has some example git send-email stuff:

http://wireless.kernel.org/en/developers/Documentation/git-guide

  Luis
