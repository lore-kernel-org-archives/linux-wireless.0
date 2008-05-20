Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:16611 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbYETXNp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2008 19:13:45 -0400
Received: by wa-out-1112.google.com with SMTP id j37so2616677waf.23
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2008 16:13:44 -0700 (PDT)
Message-ID: <1ba2fa240805201613x84c62cdke2ac3a4970beb60b@mail.gmail.com> (sfid-20080521_011418_937415_5D0591E0)
Date: Wed, 21 May 2008 02:13:44 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
Subject: Re: [PATCH] iwlwifi: Fix packet injection in iwl3945 and iwl4965
Cc: "John Linville" <linville@tuxdriver.com>,
	"Zhu Yi" <yi.zhu@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Andy Green" <andy@warmcat.com>,
	"Johannes Berg" <johannes@sipsolutions.net>
In-Reply-To: <69e28c910805201556g1f28ec9fge9e23ef701db7d9a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <69e28c910805201001r78d13ec5v4c7cf933edd39c10@mail.gmail.com>
	 <1ba2fa240805201441u2182071en5d557bb8f5f28504@mail.gmail.com>
	 <69e28c910805201451r3cab72bbwe9600008c9cc105d@mail.gmail.com>
	 <1ba2fa240805201518h78f9825fw389d0afd42f0130b@mail.gmail.com>
	 <69e28c910805201526v233cf05brfb3fac060a28c33b@mail.gmail.com>
	 <1ba2fa240805201545q4084f0f3ge2c01d9537beec85@mail.gmail.com>
	 <69e28c910805201556g1f28ec9fge9e23ef701db7d9a@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 21, 2008 at 1:56 AM, Stefanik G=E1bor <netrolller.3d@gmail.=
com> wrote:
> On Tue, May 20, 2008 at 6:45 PM, Tomas Winkler <tomasw@gmail.com> wro=
te:
>> Need to add if (sta_is !=3D bcast)  otherwise this will drop all you=
r
>> injected packets.
>
> Did you mean if (sta_id !=3D priv->hw_setting.bcast_sta_id)? Because
> there is no "sta_is" variable.

j=F3 =E9jszak=E1t!

> --
> Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
>
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
