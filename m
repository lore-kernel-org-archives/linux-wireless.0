Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62894 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756088Ab2B2KZh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 05:25:37 -0500
Received: by iagj37 with SMTP id j37so2461720iag.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Feb 2012 02:25:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1330508203-5454-1-git-send-email-florian@openwrt.org>
References: <20120215145231.80704988jhf2taxc@www.81.fi> <1330508203-5454-1-git-send-email-florian@openwrt.org>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 29 Feb 2012 21:25:16 +1100
Message-ID: <CAGRGNgXgSgEoKM7YkvbrbVwwmDXP2fnZu=AKyi6+uq4xYSeR+A@mail.gmail.com> (sfid-20120229_112541_109063_ED84374C)
Subject: Re: [PATCH v2] zd1211rw: wait between setting hash table and powering
 radio on
To: Florian Fainelli <florian@openwrt.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	dsd@gentoo.org, kune@deine-taler.de, jussi.kivilinna@mbnet.fi
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Florian,

On Wed, Feb 29, 2012 at 20:36, Florian Fainelli <florian@openwrt.org> wrote:
> +       /* Wait after setting the mutlicast hash table and powering on

I hate to, but you've spelled multicast mutlicast.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
