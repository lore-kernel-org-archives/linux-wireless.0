Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:45364 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbZJTXVn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2009 19:21:43 -0400
MIME-Version: 1.0
In-Reply-To: <e3511b0c31dd03889a221c947dec2c80.squirrel@webmail.xs4all.nl>
References: <4ADE2773.8020507@gmail.com> <e3511b0c31dd03889a221c947dec2c80.squirrel@webmail.xs4all.nl>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 21 Oct 2009 08:21:28 +0900
Message-ID: <43e72e890910201621t6691cf08kb62478fcba2fe097@mail.gmail.com>
Subject: Re: No support for Fritz!WLAN USB N2.4
To: Ed Vaessen <evaessen@xs4all.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 21, 2009 at 7:10 AM, Ed Vaessen <evaessen@xs4all.nl> wrote:
> To my surprise I found that it seems that the driver for Fritz!WLAN USB
> N2.4 is not longer supported. At least, the last tarballs I got do not
> compile them anymore. Their code is still there but no module with the
> name ar9170 is built. Modules from the same group, like ath5k and ath9k
> are built.
> Am I missing something?

What kernel are you on? ar9170 only builds on >= 2.6.29 due to some
difficulty in backporting some USB code which ar9170 uses.

  Luis
