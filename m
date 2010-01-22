Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:34173 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754226Ab0AVV7c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 16:59:32 -0500
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH 0/5] b43: more N-PHY stuff
Date: Fri, 22 Jan 2010 22:59:26 +0100
Cc: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	=?utf-8?q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>,
	linux-wireless@vger.kernel.org
References: <1264121596-9616-1-git-send-email-zajec5@gmail.com> <69e28c911001220701n7de4f943t60a9eda2b7791608@mail.gmail.com> <b170af451001221247j1b380703w4c09b5fdd601466b@mail.gmail.com>
In-Reply-To: <b170af451001221247j1b380703w4c09b5fdd601466b@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <201001222259.28933.mb@bu3sch.de>
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 22 January 2010 21:47:03 Rafał Miłecki wrote:
> As you can see I've used git send-email for submission this time! I've
> no idea what I did wrong that patch 1/5 was sent incorrectly. I just
> generated patches with
> git format-patch --cover-letter -o b43
> , then modified 0000-...patch (ONLY this one) and finally sent all
> patches from b43 directory.

The mails may be re-encoded on intermediate mailservers.
My server, for example, re-encodes all of your mails to base64.
(or it may be the list-mailserver re-encoding the mails, because by server
doesn't advertise the correct flags, I dunno...)
I don't know why it does this, however. I'm still pretty sure that it's related
to the characters in your name. Does anybody has an idea how to fix this? I'm using exim.

-- 
Greetings, Michael.
