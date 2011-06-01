Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:60323 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758768Ab1FAL7o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:59:44 -0400
Received: by qwk3 with SMTP id 3so2538791qwk.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Jun 2011 04:59:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
Date: Wed, 1 Jun 2011 13:59:43 +0200
Message-ID: <BANLkTinwvwauMOMXiFnUTnDonfB2oSxdRw@mail.gmail.com> (sfid-20110601_135947_626284_1AF9945E)
Subject: Re: [PATCH 01/83] staging: brcm80211: removed unused Broadcom
 specific ioctls codes
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Roland Vossen <rvossen@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/6/1 Roland Vossen <rvossen@broadcom.com>:
> Code cleanup. Removal of code that is not invoked.

Have you heard of "Release early, release often"? It's something, we
like here...

I've no idea who will try to review 83 patches :|

And you didn't even send [00/83] with summary.

-- 
Rafał
