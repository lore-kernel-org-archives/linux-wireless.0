Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f204.google.com ([209.85.223.204]:49327 "EHLO
	mail-iw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271AbZHZUny convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 16:43:54 -0400
Received: by iwn42 with SMTP id 42so373486iwn.33
        for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2009 13:43:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A955CD0.6040604@lwfinger.net>
References: <4a5cf0b4.F1C7R/E9sD5tpPd2%Larry.Finger@lwfinger.net>
	<4A94B01E.9040309@gmail.com> <20090826150323.GA2807@tuxdriver.com>
	<4A955CD0.6040604@lwfinger.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 26 Aug 2009 13:43:36 -0700
Message-ID: <43e72e890908261343i3c8097dbs2ac8a4c176ec82d4@mail.gmail.com>
Subject: Re: [PATCH] rtl8187: Fix for kernel oops when unloading with LEDs
	enabled
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Richard Farina <sidhayn@gmail.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 26, 2009 at 9:03 AM, Larry Finger<Larry.Finger@lwfinger.net> wrote:
> John W. Linville wrote:
>>
>> The above commit is in linux-2.6 since v2.6.31-rc2.  If it isn't in
>> compat-wireless, I have no idea why.
>
> It is - I looked at the code.

Just a heads up -- I pull "stable" code for compat-wireless using
hpa's tree, not Linus:

git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-allstable.git

Its convenient for me as I get to have branches for each kernel
release. Regardless though hpa seems to update this stable tree when
Linus updates his, so its at rc7 now for the master branch. The code
pulled into the stable compat-wireless stuff then is from the latest
stable code 2.6.2x.y or Linus' latest rc as on hpa's master branch.

  Luis
