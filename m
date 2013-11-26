Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:46893 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692Ab3KZGz2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Nov 2013 01:55:28 -0500
Received: by mail-vc0-f174.google.com with SMTP id id10so3549285vcb.33
        for <linux-wireless@vger.kernel.org>; Mon, 25 Nov 2013 22:55:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <000601cee980$a2d1b0a0$e87511e0$%han@samsung.com>
References: <000601cee980$a2d1b0a0$e87511e0$%han@samsung.com>
Date: Mon, 25 Nov 2013 22:55:27 -0800
Message-ID: <CA++WF2NwwnFNOLUaV3hAGbHXttC8gzt1RJ6Ubr0cOHRhVZ8BoA@mail.gmail.com> (sfid-20131126_075532_204681_068134D9)
Subject: Re: [PATCH 1/3] wireless: ipw2100: remove unnecessary pci_set_drvdata()
From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Jingoo,

On 24 November 2013 17:49, Jingoo Han <jg1.han@samsung.com> wrote:
> The driver core clears the driver data to NULL after device_release
> or on probe failure. Thus, it is not needed to manually clear the
> device driver data to NULL.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---

Looks fine, thanks.


Stanislav.
