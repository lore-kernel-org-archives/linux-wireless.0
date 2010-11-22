Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41561 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756634Ab0KVSNX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 13:13:23 -0500
Received: by iwn38 with SMTP id 38so264662iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 22 Nov 2010 10:13:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1290438027-20179-2-git-send-email-luciano.coelho@nokia.com>
References: <1290438027-20179-1-git-send-email-luciano.coelho@nokia.com> <1290438027-20179-2-git-send-email-luciano.coelho@nokia.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 22 Nov 2010 10:13:02 -0800
Message-ID: <AANLkTinrKyw-EHKrt5WKbHjbiQUM7Vhz3MR3n8OdWpzf@mail.gmail.com>
Subject: Re: [PATCH 1/1] compat-wireless: apply changes needed after
 wl1271->wl12xx renaming
To: luciano.coelho@nokia.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 22, 2010 at 7:00 AM,  <luciano.coelho@nokia.com> wrote:
> From: Luciano Coelho <luciano.coelho@nokia.com>
>
> This patch changes the occurrences of wl1271 in the Makefile, README and in
> the scripts to wl12xx, since the driver has been renamed.
>
> Also remove the wl1271_ prefix from the filenames.
>
> Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>

Applied and pushed, thanks!

  Luis
