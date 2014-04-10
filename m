Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:63779 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965088AbaDJQ1r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2014 12:27:47 -0400
Received: by mail-oa0-f43.google.com with SMTP id eb12so4769691oac.16
        for <linux-wireless@vger.kernel.org>; Thu, 10 Apr 2014 09:27:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1396360976-28657-6-git-send-email-heikki.krogerus@linux.intel.com>
References: <1396360976-28657-1-git-send-email-heikki.krogerus@linux.intel.com>
	<1396360976-28657-6-git-send-email-heikki.krogerus@linux.intel.com>
Date: Thu, 10 Apr 2014 18:27:47 +0200
Message-ID: <CACRpkdbuvyEQVFv07Bq3dAeGEZr-MuJKJ5mYqdzicROJLwvHDw@mail.gmail.com> (sfid-20140410_182752_245859_1340BE34)
Subject: Re: [PATCHv3 5/5] net: rfkill: gpio: hard-code the gpio names
From: Linus Walleij <linus.walleij@linaro.org>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Chen-Yu Tsai <wens@csie.org>,
	Rhyland Klein <rklein@nvidia.com>,
	Marc Dietrich <marvin24@gmx.de>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Alexandre Courbot <gnurou@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 1, 2014 at 4:02 PM, Heikki Krogerus
<heikki.krogerus@linux.intel.com> wrote:

> There is no need to dynamically generate the names. This
> will fix a static checker warning..
>
> net/rfkill/rfkill-gpio.c:144 rfkill_gpio_probe()
>     warn: variable dereferenced before check 'rfkill->name'
>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

Excellent,
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
