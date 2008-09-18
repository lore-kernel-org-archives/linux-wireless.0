Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.185]:59057 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbYIRO00 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 10:26:26 -0400
Received: by fk-out-0910.google.com with SMTP id 18so3389968fkq.5
        for <linux-wireless@vger.kernel.org>; Thu, 18 Sep 2008 07:26:24 -0700 (PDT)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [RFC] b43: A patch for control of the radio LED using rfkill
Date: Thu, 18 Sep 2008 16:26:21 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <48d1e227.AmBwRnEuhx6kxlHv%Larry.Finger@lwfinger.net> <200809181553.29140.IvDoorn@gmail.com> <20080918142133.GF1583@khazad-dum.debian.net>
In-Reply-To: <20080918142133.GF1583@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809181626.21945.IvDoorn@gmail.com> (sfid-20080918_162629_585231_715DDA8B)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> I don't know enough about the mac80211 layer and b43 to know whether
> dev->phy.radio_on matches the hardware or not.

It is the software request from mac80211 which ultimately comes from the user.

Ivo

