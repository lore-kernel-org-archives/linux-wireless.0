Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57949 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab1HZOvn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 10:51:43 -0400
From: Christian Lamparter <chunkeey@googlemail.com>
To: Axel Lin <axel.lin@gmail.com>
Subject: Re: [PATCH] p54spi: add "spi:" prefix for stlc45xx modalias
Date: Fri, 26 Aug 2011 16:51:29 +0200
Cc: linux-kernel@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <1314340499.25655.1.camel@phoenix>
In-Reply-To: <1314340499.25655.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201108261651.29640.chunkeey@googlemail.com> (sfid-20110826_165216_458042_54BE4EEE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, August 26, 2011 08:34:59 AM Axel Lin wrote:
> Since commit e0626e38 (spi: prefix modalias with "spi:"),
> the spi modalias is prefixed with "spi:".
> 
> This patch adds "spi:" prefix for modalias of stlc45xx.
> Also move it to be group with other modalias.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
sure, can't say no.
Acked-By: Christian Lamparter <chunkeey@googlemail.com>
