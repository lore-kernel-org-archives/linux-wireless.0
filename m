Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:19153 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab0CAKSZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Mar 2010 05:18:25 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH] ath9k: decrease size of ath9k.ko
Date: Mon, 1 Mar 2010 13:19:12 +0100
Cc: Larry Finger <Larry.Finger@lwfinger.net>, lrodriguez@atheros.com,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	linville@tuxdriver.com, johannes@sipsolutions.net,
	stable@kernel.org
References: <1267289803-6795-1-git-send-email-tom.leiming@gmail.com> <4B89520D.1000209@lwfinger.net> <d82e647a1002271852j20006c27i92d1f7a99e032f2d@mail.gmail.com>
In-Reply-To: <d82e647a1002271852j20006c27i92d1f7a99e032f2d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201003011319.12395.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Either 'char' or 'u8' is OK, since both has one-byte size, isn't it?

Besides Johannes' comment: char is signed, u8 is unsigned. This can sometimes 
byte you.

-- 
http://www.holgerschurig.de
