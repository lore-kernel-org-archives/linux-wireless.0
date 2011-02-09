Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:33305 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755036Ab1BIAyj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Feb 2011 19:54:39 -0500
Received: by mail-qw0-f42.google.com with SMTP id 4so4796030qwe.29
        for <linux-wireless@vger.kernel.org>; Tue, 08 Feb 2011 16:54:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1296633577-15199-1-git-send-email-eliad@wizery.com>
References: <1296633577-15199-1-git-send-email-eliad@wizery.com>
Date: Tue, 8 Feb 2011 22:54:37 -0200
Message-ID: <AANLkTim=+LT7bj_1gD2=oEMWzmL=UuwU2H9TdKOQ8c_4@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] wl12xx: move to new firmware (6.1.3.50.49)
From: "Coelho, Luciano" <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 2, 2011 at 5:59 AM, Eliad Peller <eliad@wizery.com> wrote:
> Make the wl12xx driver start working with the latest
> wl12xx firmware (6.1.3.50.49).
>
> The patchset only migrates exisiting functionality.
> (i.e. it doesn't contain the new firmware features)
>
> Note that this new firmware is not backward compatible with the
> current firmware, so a new firmware name is being used.

Applied and pushed.  Thanks, Eliad!

--
Cheers,
Luca.
