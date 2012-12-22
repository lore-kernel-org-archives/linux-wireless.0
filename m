Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:34991 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab2LVLM1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2012 06:12:27 -0500
Received: by mail-ee0-f51.google.com with SMTP id d4so2793364eek.10
        for <linux-wireless@vger.kernel.org>; Sat, 22 Dec 2012 03:12:24 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Sean Patrick Santos <quantheory@gmail.com>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH -stable 3.7] carl9170: fix -EINVAL bailout during init with !CONFIG_MAC80211_MESH
Date: Sat, 22 Dec 2012 12:05:17 +0100
References: <201212220435.24719.chunkeey@googlemail.com> <CAFR4Aqa3qVQaLGYDwmAvOm8S5=0DkwtsDXMVGUNuOLuvkeAAeA@mail.gmail.com>
In-Reply-To: <CAFR4Aqa3qVQaLGYDwmAvOm8S5=0DkwtsDXMVGUNuOLuvkeAAeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201212221205.18151.chunkeey@googlemail.com> (sfid-20121222_121231_158529_47073B18)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 22 December 2012 05:21:24 Sean Patrick Santos wrote:
> I tested this patch and it solved my problem. The driver now works
> correctly without CONFIG_MAC80211_MESH.

Thank you for testing! I've readded John, so he can add
this tag to the commmit:

Tested-by: Sean Patrick Santos <quantheory@gmail.com>

Regards,

Christian
