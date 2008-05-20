Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.183]:32812 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761976AbYETW4W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2008 18:56:22 -0400
Received: by py-out-1112.google.com with SMTP id u52so2650960pyb.10
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2008 15:56:22 -0700 (PDT)
Message-ID: <69e28c910805201556g1f28ec9fge9e23ef701db7d9a@mail.gmail.com> (sfid-20080521_005657_448024_8DF054AD)
Date: Tue, 20 May 2008 18:56:21 -0400
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: [PATCH] iwlwifi: Fix packet injection in iwl3945 and iwl4965
Cc: "John Linville" <linville@tuxdriver.com>,
	"Zhu Yi" <yi.zhu@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Andy Green" <andy@warmcat.com>,
	"Johannes Berg" <johannes@sipsolutions.net>
In-Reply-To: <1ba2fa240805201545q4084f0f3ge2c01d9537beec85@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <69e28c910805201001r78d13ec5v4c7cf933edd39c10@mail.gmail.com>
	 <1ba2fa240805201441u2182071en5d557bb8f5f28504@mail.gmail.com>
	 <69e28c910805201451r3cab72bbwe9600008c9cc105d@mail.gmail.com>
	 <1ba2fa240805201518h78f9825fw389d0afd42f0130b@mail.gmail.com>
	 <69e28c910805201526v233cf05brfb3fac060a28c33b@mail.gmail.com>
	 <1ba2fa240805201545q4084f0f3ge2c01d9537beec85@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 20, 2008 at 6:45 PM, Tomas Winkler <tomasw@gmail.com> wrote:
> Need to add if (sta_is != bcast)  otherwise this will drop all your
> injected packets.

Did you mean if (sta_id != priv->hw_setting.bcast_sta_id)? Because
there is no "sta_is" variable.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
