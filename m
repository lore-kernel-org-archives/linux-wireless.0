Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:6499 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbYKMKq2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2008 05:46:28 -0500
Received: by yw-out-2324.google.com with SMTP id 9so374128ywe.1
        for <linux-wireless@vger.kernel.org>; Thu, 13 Nov 2008 02:46:26 -0800 (PST)
Message-ID: <dac45060811130246n41c9983fx2f06f85946b20c1c@mail.gmail.com> (sfid-20081113_114634_398140_CE7AD152)
Date: Thu, 13 Nov 2008 12:46:25 +0200
From: "Mark Ryden" <markryde@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Master mode in iw
Cc: johannes@sipsolutions.net
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I have a question about the iw: is it possible to
set with it an interface to be in master mode ? (as in the case of
Access Point)

I had git cloned the sources according to the URL from
http://linuxwireless.org/en/users/Documentation/iw; and as far
as I understand from the code, it is not implemented yet. It will only
display when an interface is in master mode (but you cannot set to master mode).

I want to verify this point and ask if there is an inhernet reason for
not implementing this (setting other modes,
like mesh and monitor, is implemented). Or is it simply on the to-do list ?

Regards,
Mark
