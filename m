Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([187.115.55.249]:44856 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab0LUN3v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 08:29:51 -0500
Date: Tue, 21 Dec 2010 11:29:48 -0200
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Hin-Tak Leung <htl10@users.sourceforge.net>
Subject: Re: [PATCH] rtl818x: move rtl8180 and rtl8187 to separate
 subdirectories
Message-ID: <20101221112948.1aeeb444@gotham.conectiva>
In-Reply-To: <4D0FF4DC.4010409@lwfinger.net>
References: <1292876551-26749-1-git-send-email-linville@tuxdriver.com>
	<4D0FF4DC.4010409@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 20 Dec 2010 18:29:16 -0600
Larry Finger <Larry.Finger@lwfinger.net> wrote:

> On 12/20/2010 02:22 PM, John W. Linville wrote:
> > These drivers share one header file, but nothing else.  Worse, both
> > drivers use the rtl8225 part with different register settings.  The
> > results has been some ugly naming -- let's simplify that.
> > 
> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
> > ---
> 
> This is a good time to change this as I have heard from Realtek that their
> RTL8187SE driver that uses mac80211 is running, but not yet stable. When it is,
> a decision can be made if it should be in .../rtl818x/rtl8187/ or
> .../rtl818x/rtl8187se/.
> 
> The new driver will also allow the staging driver to be removed.

Ack from me too, it stays cleaner with the change.

> 
> Larry
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
[]'s
Herton
