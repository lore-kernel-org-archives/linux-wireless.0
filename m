Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:14292 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758155Ab3BYO1e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2013 09:27:34 -0500
Cc: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qca.qualcomm.com>
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Trevor Cullen <tcc@innovelec.co.uk>
Subject: Re: AR9374 Rev 1.3/RevB USB Linux drivers?
References: <008901ce1359$8bbdc550$a3394ff0$@innovelec.co.uk>
Date: Mon, 25 Feb 2013 16:27:19 +0200
In-Reply-To: <008901ce1359$8bbdc550$a3394ff0$@innovelec.co.uk> (Trevor
	Cullen's message of "Mon, 25 Feb 2013 13:10:55 +0000")
Message-ID: <87ehg4lb94.fsf@kamboji.qca.qualcomm.com> (sfid-20130225_152738_105058_2D659AC0)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Trevor Cullen <tcc@innovelec.co.uk> writes:

> We are trying to install drivers for AR9374 USB with Rev1.3/Rev B silicon but
> have been told the current driver only supports Rev1.1/Rev A silicon.
>
> What is the issue? When will the driver be bumped to worked with the new
> silicon?

What ath6kl version are you using exactly? From kernel or from
compat-wireless? Where did you get it? What is your kernel version?

The latest version of ath6kl does support ar6004 hw1.3.

What's RevB? I haven't seen that before.

-- 
Kalle Valo
