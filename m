Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.229]:4865 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbYGYVtu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jul 2008 17:49:50 -0400
Received: by rv-out-0506.google.com with SMTP id k40so3628201rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jul 2008 14:49:49 -0700 (PDT)
Message-ID: <69e28c910807251449h6e389cd2n72de63c558338335@mail.gmail.com> (sfid-20080725_234954_739104_7D6A5E99)
Date: Fri, 25 Jul 2008 23:49:49 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Zhu Yi" <yi.zhu@intel.com>
Subject: Re: [ipw3945-devel] [PATCH] iwlwifi: Enable packet injection for iwl4965
Cc: "=?ISO-8859-1?Q?St=E9phane_Jourdois?=" <stephane@jourdois.fr>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linux-kernel@vger.kernel.org,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1216951133.2705.227.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <69e28c910807181205m6dd0cdcek83f9717bf1ac9dcc@mail.gmail.com>
	 <69e28c910807220454q7c8371e1m11b1015ed8398758@mail.gmail.com>
	 <4885DDC4.2060609@googlemail.com> <4886235F.6010407@jourdois.fr>
	 <1216951133.2705.227.camel@debian.sh.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/7/25 Zhu Yi <yi.zhu@intel.com>:
> On Tue, 2008-07-22 at 20:13 +0200, St=E9phane Jourdois wrote:
>> but this commit is for iwl3945, not iwl4965.
>> The patch for iwl4965 is currently not in any git tree.
>
> We are waiting for more "confirmed success" response before merging i=
t.
>
> Thanks,
> -yi

I think we now have a lot of "confirmed success", as aircrack-ng users
are now using this card with aireplay-ng - injecting association
frames is unstable, but injecting data packets works.

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
