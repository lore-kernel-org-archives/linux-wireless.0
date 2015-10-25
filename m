Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:36792 "EHLO
	mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbbJYWvx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2015 18:51:53 -0400
Received: by lffz202 with SMTP id z202so129855519lff.3
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2015 15:51:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1444862012-25376-1-git-send-email-martin.blumenstingl@googlemail.com>
References: <1444862012-25376-1-git-send-email-martin.blumenstingl@googlemail.com>
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Sun, 25 Oct 2015 23:51:32 +0100
Message-ID: <CAFBinCA5-fqAQJt5jd8986kBqxGvK+HQx2oH2MpWB3XkgoPJNQ@mail.gmail.com> (sfid-20151025_235157_098204_911744D5)
Subject: Re: [RFC] ath9k: Simplify and fix eeprom endianness swapping
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org, ath9k-devel@qca.qualcomm.com,
	nbd@openwrt.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 15, 2015 at 12:33 AM, Martin Blumenstingl
<martin.blumenstingl@googlemail.com> wrote:
> I have tested my patch on a single AR9227 device and there it's
> working fine. It would be great if more people would give this a go
> before merging this patch.
I have just tested it on a second AR9227 device which uses the "other
swapped" EEPROM format.
Unfortunately my patch seems to break that, so please do not merge it for now.

I will send an updated patch once I have sorted this out.
