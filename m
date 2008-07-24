Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:47589 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623AbYGXVOG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2008 17:14:06 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Stefanik =?iso-8859-1?q?G=E1bor?=" <netrolller.3d@gmail.com>
Subject: Re: b43: Debugging PHY TX errors
Date: Thu, 24 Jul 2008 23:13:19 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <200807241330.15439.mb@bu3sch.de> <69e28c910807240806t24a1c2f9l8814a2d98aac34d@mail.gmail.com>
In-Reply-To: <69e28c910807240806t24a1c2f9l8814a2d98aac34d@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <200807242313.19808.mb@bu3sch.de> (sfid-20080724_231413_342319_485918B7)
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 24 July 2008 17:06:39 Stefanik G=E1bor wrote:
> Please add this functionality to the open-source firmware too.

No this is very intrusive.
The hacked firmware restarts itself on a PHY error. We don't want this =
in
a production environment, because as I said it will disturb your
connectivity (a PHY error every few minutes with vanilla firmware will =
not).

I also forgot to say that the patcher currently only works for ucode5.f=
w.
So if your device uses another firmware and you really want to debug
a PHY error, I can port the patcher to your version. Just poke me.

--=20
Greetings Michael.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
