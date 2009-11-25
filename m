Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:33749 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935168AbZKYWSZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 17:18:25 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: Re: RTL8187 warnings on suspend
Date: Wed, 25 Nov 2009 23:18:14 +0100
Cc: "Hin-Tak Leung" <htl10@users.sourceforge.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <200911251626.15959.mb@bu3sch.de> <200911252157.41899.mb@bu3sch.de> <200911251944.25381.herton@mandriva.com.br>
In-Reply-To: <200911251944.25381.herton@mandriva.com.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200911252318.15738.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 25 November 2009 22:44:25 Herton Ronaldo Krzesinski wrote:
> Hmm strange, reviewing it now I only see a missing #ifdef CONFIG_RTL8187_LEDS
> around rtl8187_leds_start inside rtl8187_start. Despite it, the patch worked
> here, may be something I'm not seeing...

http://bu3sch.de/misc/rtl8187.JPG

-- 
Greetings, Michael.
