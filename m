Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23105.mail.ird.yahoo.com ([217.146.189.45]:40471 "HELO
	web23105.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753022AbYKEWMx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 17:12:53 -0500
Date: Wed, 5 Nov 2008 22:05:31 +0000 (GMT)
From: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
Subject: Re: [RFC/RFT PATCH v2 2/2] rtl8187: feedback transmitted packets using tx close descriptor for 8187B
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>,
	Andrea Merello <andrea.merello@gmail.com>
In-Reply-To: <200811051936.46361.herton@mandriva.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-ID: <557861.93619.qm@web23105.mail.ird.yahoo.com> (sfid-20081105_231258_208385_ECBC5E35)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Wed, 5/11/08, Herton Ronaldo Krzesinski <herton@mandriva.com.br> wrote:

> Don't know about fc10 kernel, but the changes also
> include mac80211.ko

Yes, I know the change includes mac802111.ko, that's why I was surprised that mac80211.ko didn't get built with compat-wireless. 

Turned out that fc10 kernels have mac80211 built-in rather than as modules, so there is no way of replacing them with compat-wireless. I am going to install a 2.6.27.x-fc9... (I am using a 2.6.27.x-fc10 for some x11-xorg drivers because there wasn't a 2.6.27.x-fc9 when I looked - and the first 2.6.27-x.fc9 has just hit koji).

I'll fill a bug in redhat's bugzilla. :-).


      
