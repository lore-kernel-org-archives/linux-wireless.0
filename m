Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:55997 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754389AbZHTNel (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2009 09:34:41 -0400
From: Michael Buesch <mb@bu3sch.de>
To: gregor kowski <gregor.kowski@gmail.com>
Subject: Re: [PATCHv4] b43 add harware tkip
Date: Thu, 20 Aug 2009 15:34:39 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <83a869cd0908191335u723f62c6p119ec4ed8cfb51c5@mail.gmail.com>
In-Reply-To: <83a869cd0908191335u723f62c6p119ec4ed8cfb51c5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200908201534.39671.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 19 August 2009 22:35:45 gregor kowski wrote:
> Update v4 : add a warn_on in b43_op_update_tkip_key, update to last
> driver change (key API).
> Update v3 : add a module parameter to enable hw tkip, Coding style
> fix, locking fix
> Update v2 : work with qos, implement dump key, fix an issue with setting
> random value on tkip key clear.
> 
> This add hardware tkip for b43.
> 
> Signed-off-by: Gregor Kowski <gregor.kowski@gmail.com>

Acked-by: Michael Buesch <mb@bu3sch.de>

-- 
Greetings, Michael.
