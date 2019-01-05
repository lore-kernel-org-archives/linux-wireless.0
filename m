Return-Path: <SRS0=nI2m=PN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AADFC43387
	for <linux-wireless@archiver.kernel.org>; Sat,  5 Jan 2019 19:50:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD753222FB
	for <linux-wireless@archiver.kernel.org>; Sat,  5 Jan 2019 19:50:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="5KCQH7Lf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbfAETub (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 5 Jan 2019 14:50:31 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34864 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726270AbfAETub (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Jan 2019 14:50:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch; s=20171124;
        h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=wRJ5mPaKheCREZyoY5Ec7/4zoG4fAiMtsgjcai9GYsk=;
        b=5KCQH7Lf+XFrzjzL9ndxx5ZCsik1Tbv82l4QFgfG9dvDwk6jGBBXcnvuzx0fgkhrCTdunSRnX3KN3nbliw6u/Uy1tREDg98pyVV4uzDayYfDqUVYRx0CGu+FzopVo63U3TadFeR/73Kph2tk7dRPUnomN0pBKKsLOYQEDa6ZtlM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.84_2)
        (envelope-from <andrew@lunn.ch>)
        id 1gfrxb-0008Rk-Gh; Sat, 05 Jan 2019 20:50:19 +0100
Date:   Sat, 5 Jan 2019 20:50:19 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/4] rtlwifi: rtl8723ae: Don't use dm.undec_sm_pwdb
 for input
Message-ID: <20190105195019.GB30438@lunn.ch>
References: <DB7PR07MB5353A56F7F5BD0EEC355346FE48F0@DB7PR07MB5353.eurprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB7PR07MB5353A56F7F5BD0EEC355346FE48F0@DB7PR07MB5353.eurprd07.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, Jan 05, 2019 at 06:39:02PM +0000, Bernd Edlinger wrote:
>  gain control when no beacon was received in the connected state

Hi Bernd

Your patch subject line is too long, so it got chopped in half. Please
use something shorter.

    Andrew
