Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:58118 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752793AbcIMD2t (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 23:28:49 -0400
Date: Mon, 12 Sep 2016 20:28:45 -0700 (PDT)
Message-Id: <20160912.202845.1229112190826763502.davem@davemloft.net> (sfid-20160913_052911_793156_BB56DCA8)
To: javier@osg.samsung.com
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de,
        sony.chacko@qlogic.com, peppe.cavallaro@st.com,
        linux-net-drivers@solarflare.com, fw@strlen.de,
        bkenward@solarflare.com, geert@linux-m68k.org,
        ecree@solarflare.com, kvalo@codeaurora.org, mw@semihalf.com,
        a@unstable.cc, intel-wired-lan@lists.osuosl.org,
        f.fainelli@gmail.com, felipe.balbi@linux.intel.com,
        gregory.clement@free-electrons.com, Dept-HSGLinuxNICDev@qlogic.com,
        jeffrey.t.kirsher@intel.com, mugunthanvnm@ti.com, andrew@lunn.ch,
        klassert@mathematik.tu-chemnitz.de, sgruszka@redhat.com,
        kda@linux-powerpc.org, qiang.zhao@freescale.com,
        netdev@vger.kernel.org, gerlando.falauto@keymile.com,
        linux-wireless@vger.kernel.org, ionut@badula.org,
        venza@brownhat.org, alexandre.torgue@st.com
Subject: Re: [PATCH 00/15] drivers: net: use IS_ENABLED() instead of
 checking for built-in or module
From: David Miller <davem@davemloft.net>
In-Reply-To: <1473689026-6983-1-git-send-email-javier@osg.samsung.com>
References: <1473689026-6983-1-git-send-email-javier@osg.samsung.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Martinez Canillas <javier@osg.samsung.com>
Date: Mon, 12 Sep 2016 10:03:31 -0400

> This trivial series is similar to [0] for net/ that you already merged, but
> for drivers/net. The patches replaces the open coding to check for a Kconfig
> symbol being built-in or module, with IS_ENABLED() macro that does the same.

Series applied, thanks.
