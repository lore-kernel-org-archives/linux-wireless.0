Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64230 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756917Ab0G2TD1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jul 2010 15:03:27 -0400
Received: by wwj40 with SMTP id 40so697949wwj.1
        for <linux-wireless@vger.kernel.org>; Thu, 29 Jul 2010 12:03:24 -0700 (PDT)
Message-ID: <4C51D096.7090607@lwfinger.net>
Date: Thu, 29 Jul 2010 14:03:50 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Kirill Zut <kirill.zut@promwad.com>,
	linux-wireless@vger.kernel.org,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: Re: [PATCH 2.6.34] rtl8187: ad-hoc mode support
References: <201007291835.46159.kirill.zut@promwad.com> <20100729180426.GC2424@tuxdriver.com>
In-Reply-To: <20100729180426.GC2424@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/29/2010 01:04 PM, John W. Linville wrote:
> Don't you need something to make it beacon?

Indeed he does. This code allows the user to set ad-hoc mode, but I could not
establish a connection. The setup that I used worked for a b43 - b43 link, but
failed if either end used rtl8187. NACK.

Larry

