Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39693 "HELO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932196AbZLMCYg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Dec 2009 21:24:36 -0500
Date: Sat, 12 Dec 2009 20:22:32 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8180: Remove usage of deprecated 'qual'
Message-ID: <20091213012232.GA12937@tuxdriver.com>
References: <4b242f9e.4JOejhV35R7ixmmP%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <4b242f9e.4JOejhV35R7ixmmP%Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Dec 12, 2009 at 06:04:46PM -0600, Larry Finger wrote:
> When building rtl8180, the following warning occurs:
> 
>   CC [M]  drivers/net/wireless/rtl818x/rtl8180_dev.o
> drivers/net/wireless/rtl818x/rtl8180_dev.c: In function ‘rtl8180_handle_rx’:
> drivers/net/wireless/rtl818x/rtl8180_dev.c:135: warning: ‘qual’ is deprecated
>     (declared at include/net/mac80211.h:562)
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

FWIW, I think Johannes has a hunk like this in his patch to finally
remove qual.

John
-- 
John W. Linville                Someday the world will need a hero, and you
linville@tuxdriver.com                  might be all we have.  Be ready.
