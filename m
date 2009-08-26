Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:64859 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbZHZQEu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 12:04:50 -0400
Received: by bwz19 with SMTP id 19so240588bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2009 09:04:50 -0700 (PDT)
Message-ID: <4A955CD0.6040604@lwfinger.net>
Date: Wed, 26 Aug 2009 11:03:28 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Richard Farina <sidhayn@gmail.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8187: Fix for kernel oops when unloading with LEDs
 enabled
References: <4a5cf0b4.F1C7R/E9sD5tpPd2%Larry.Finger@lwfinger.net> <4A94B01E.9040309@gmail.com> <20090826150323.GA2807@tuxdriver.com>
In-Reply-To: <20090826150323.GA2807@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> 
> The above commit is in linux-2.6 since v2.6.31-rc2.  If it isn't in
> compat-wireless, I have no idea why.

It is - I looked at the code.

Larry

