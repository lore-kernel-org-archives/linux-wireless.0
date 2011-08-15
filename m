Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:50170 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab1HOVDb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2011 17:03:31 -0400
Received: by yie30 with SMTP id 30so3408446yie.19
        for <linux-wireless@vger.kernel.org>; Mon, 15 Aug 2011 14:03:30 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 15 Aug 2011 17:03:30 -0400
Message-ID: <CA+7oygcN-RykWDg8=h9uKDgnKPFgmaY-cxt3QRZD4ZuVnMRmgw@mail.gmail.com> (sfid-20110815_230335_111487_E621A957)
Subject: any way to activate a scan in Atheros' monitor mode?
From: George Nychis <gnychis@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Is there anything out of the box, before I go hacking, that supports
initiating a channel scan for an ath9k card when in monitoring mode?
Right now, I am implementing a wrapper around iwconfig to increment
the channel, but its a little fuzzy when it's implemented at a higher
layer with delays to change the channel that I can't account for.

- George
