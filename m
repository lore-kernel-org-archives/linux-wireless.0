Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41202 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932271Ab1KGOnE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 09:43:04 -0500
Received: by bke11 with SMTP id 11so3640752bke.19
        for <linux-wireless@vger.kernel.org>; Mon, 07 Nov 2011 06:43:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1319313081-28722-1-git-send-email-guy@wizery.com>
References: <1319313081-28722-1-git-send-email-guy@wizery.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Mon, 7 Nov 2011 16:42:46 +0200
Message-ID: <CA+XVXffQgYtS-0-YOzFxD1ppVbWEeNjnUch_5nPxPqmzJb86+Q@mail.gmail.com> (sfid-20111107_154309_633500_2E412272)
Subject: Re: [PATCH v2 1/3] nl80211: Add probe response offload attribute
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Guy Eilam <guy@wizery.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 22, 2011 at 21:51, Guy Eilam <guy@wizery.com> wrote:
> Notify the userspace of the probe response offloading
> support by the driver.
>
> Signed-off-by: Guy Eilam <guy@wizery.com>
> ---
> v2:
> use struct wiphy instead of a function pointer
> this change made the previous second PATCH:
> "Get the probe response offloading support from the driver" irrelevant
> changed WPS to WSC

I'll revert the WSC wording to WPS in the v3 of the probe-resp
patches. Seems more appropriate in light of the new defunct AP_SME
attribute, and the naming conventions for this in hostap

Arik
