Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:34918 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S932350AbdHVL0H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Aug 2017 07:26:07 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com
Subject: [PATCH v5] brcmfmac cleanup
Date: Tue, 22 Aug 2017 12:25:20 +0100
Message-Id: <20170822112550.60311-1-ian@mnementh.co.uk> (sfid-20170822_132610_954099_7949A236)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi folks,

Arend, as requested - a respin to take account of your comments.

Unfortunately, although I've only included the patches you requested from v4,
breaking out some of the simpler changes (whitespace, macos, etc.) has grown
the set back up to 30 patches. I hope this is OK.

I've tried to include everything you asked for but may not have understood
everything you wrote, so please bear with me :) Im happy to keep at this until
it's right.

I did have to include a couple of patches from v4 that you didnt request,
because they were dependencies of ones you wanted. I've kept this as minimal
as possible, however.

The whole patchset was compile tested at each commit on 4.13-rc5.

No functional changes from v4 (other than this is a subset of the v4 series).

-Ian
