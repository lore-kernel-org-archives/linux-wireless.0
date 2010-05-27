Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f216.google.com ([209.85.219.216]:51986 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757587Ab0E0UO6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 May 2010 16:14:58 -0400
Received: by ewy8 with SMTP id 8so116912ewy.28
        for <linux-wireless@vger.kernel.org>; Thu, 27 May 2010 13:14:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1274740231.2091.15472.camel@rchatre-DESK>
References: <AANLkTikB8WaMyIj6CTY5wfEeVDratQ1Y8W3B_JBVllBp@mail.gmail.com>
	<1274465242.12391.0.camel@abhi-desktop>
	<AANLkTilnK6lkypJkajiwUbhl6JlNR7S8dL6YzKUe2yd3@mail.gmail.com>
	<1274740231.2091.15472.camel@rchatre-DESK>
Date: Thu, 27 May 2010 22:14:54 +0200
Message-ID: <AANLkTilfa4YPPiroX5yfJ2BNRUVZH6imTvG4I8ukGjBC@mail.gmail.com>
Subject: Re: Iwlwifi and LEDS?
From: Gregy <p.gregy@gmail.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> What did you do before that does not work anymore?
>
> Reinette

No, led never gets registered in /sys/class/leds. Also I found this:
http://article.gmane.org/gmane.linux.kernel.wireless.general/40328/
