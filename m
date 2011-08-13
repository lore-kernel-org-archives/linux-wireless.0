Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:40554 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab1HMRLq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 13:11:46 -0400
Received: by qyk38 with SMTP id 38so254719qyk.19
        for <linux-wireless@vger.kernel.org>; Sat, 13 Aug 2011 10:11:45 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1313251364-6633-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1313251364-6633-1-git-send-email-wey-yi.w.guy@intel.com>
Date: Sat, 13 Aug 2011 19:11:45 +0200
Message-ID: <CA+icZUXkKTZogdmy4Mo=1iOCGfM_UsBtHy7x_83DHQPsySS+kw@mail.gmail.com> (sfid-20110813_191155_021002_0764C2D7)
Subject: Re: [PATCH 0/2] iwlwifi fix for 3.1
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 13, 2011 at 6:02 PM, Wey-Yi Guy <wey-yi.w.guy@intel.com> wrote:
> Fix introduced a bug: bad pointer in unload in
> commit cc1a93e68f6c0d736b771f0746e8e4186f483fdc.
>
> ALso fix bug has been introduced by:
> d593411084a56124aa9d80aafa15db8463b2d8f7
>
> Emmanuel Grumbach (2):
>  iwlagn: Revert "iwlagn: sysfs couldn't find the priv pointer"
>  iwlagn: sysfs couldn't find the priv pointer
>
> these patches are also available from wireless-2.6 branch on
>  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git
>

It's time to drop -2.6 suffix from your GIT repository?

- Sedat -
