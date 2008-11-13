Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:41637 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbYKMK6s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2008 05:58:48 -0500
To: "Mark Ryden" <markryde@gmail.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: Master mode in iw
References: <dac45060811130246n41c9983fx2f06f85946b20c1c@mail.gmail.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Thu, 13 Nov 2008 12:57:41 +0200
In-Reply-To: <dac45060811130246n41c9983fx2f06f85946b20c1c@mail.gmail.com> (ext Mark Ryden's message of "Thu\, 13 Nov 2008 12\:46\:25 +0200")
Message-ID: <87ej1f6ggq.fsf@nokia.com> (sfid-20081113_115902_797591_76F9827B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mark Ryden <markryde@gmail.com> writes:

> Hello,

Hello,

> I have a question about the iw: is it possible to
> set with it an interface to be in master mode ? (as in the case of
> Access Point)
>
> I had git cloned the sources according to the URL from
> http://linuxwireless.org/en/users/Documentation/iw; and as far
> as I understand from the code, it is not implemented yet. It will only
> display when an interface is in master mode (but you cannot set to master mode).
>
> I want to verify this point and ask if there is an inhernet reason for
> not implementing this (setting other modes,
> like mesh and monitor, is implemented). Or is it simply on the to-do list ?

You have to use hostapd. See earlier mails in this list for more
information.

-- 
Kalle Valo
