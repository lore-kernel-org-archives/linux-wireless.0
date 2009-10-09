Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:37091 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933175AbZJIHYN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2009 03:24:13 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [PATCH] libertas: remove double assignment of dev->netdev_ops
Date: Fri, 9 Oct 2009 09:22:47 +0200
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <1255034769-18882-1-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1255034769-18882-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200910090922.47834.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 08 October 2009 22:46:09 Luis R. Rodriguez wrote:
> -       dev->netdev_ops = &lbs_netdev_ops;

Acked-by: Holger Schurig <hs4233@mail.mn-solutions.de>

-- 
http://www.holgerschurig.de
