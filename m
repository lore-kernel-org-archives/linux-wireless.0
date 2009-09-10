Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:60501 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbZIJR1S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2009 13:27:18 -0400
MIME-Version: 1.0
In-Reply-To: <1252603292-20830-1-git-send-email-mjg@redhat.com>
References: <1252603292-20830-1-git-send-email-mjg@redhat.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 10 Sep 2009 10:27:01 -0700
Message-ID: <43e72e890909101027saf1ed35u23936729eccf3f92@mail.gmail.com>
Subject: Re: [PATCH 1/2] input: Add KEY_RFKILL
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-input@vger.kernel.org, linux-wireless@vger.kernel.org,
	marcel@holtmann.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 10, 2009 at 10:21 AM, Matthew Garrett <mjg@redhat.com> wrote:

> This patch adds a new keycode, KEY_RFKILL_ALL.

>  include/linux/input.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)

> +#define KEY_RFKILL             0x20c /* Key that controls all radios */

But this above is KEY_RFKILL, not KEY_RKILL_ALL. Typo?

  Luis
