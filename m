Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49067 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088Ab0JaJiG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Oct 2010 05:38:06 -0400
Received: by vws13 with SMTP id 13so2175673vws.19
        for <linux-wireless@vger.kernel.org>; Sun, 31 Oct 2010 02:38:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CCCE31A.5030608@lwfinger.net>
References: <4CCCE31A.5030608@lwfinger.net>
Date: Sun, 31 Oct 2010 10:38:03 +0100
Message-ID: <AANLkTin_dPPk8XBKWjEbuHmQJg3zok5bUcrrn99qV6dn@mail.gmail.com>
Subject: Re: Deauthentication for reason 6 using Intel 5300 in 2.6.34
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	"Zheng, Jiajia" <jiajia.zheng@intel.com>,
	ipw3945-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/10/31 Larry Finger <Larry.Finger@lwfinger.net>:
> A user on the openSUSE forum reports that the connection drops frequently when
> using 802.11n on a 5300 with a 2.6.34 kernel. It is deauthenticated for reason
> 6. He was able to stabilize the connection by disabling N mode. I think he used
> "options iwlagn 11n_disable=1 11n_disable50=1".
>
> Is this a known problem? Would the situation be improved by using
> compat-wireless? If so, is "bleeding-edge" needed?

It's fu* known problem. Intel doesn't seem to care about users, they
have fixed firmware but didn't decide to release it for 2 months.

http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2214#c19

-- 
Rafał
